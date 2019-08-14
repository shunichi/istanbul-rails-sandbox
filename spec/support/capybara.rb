module JsCoverage
  COVERAGE_DIRECTORY = '.nyc_output'

  def clean_coverage_directory
    dir_path = Rails.root.join(COVERAGE_DIRECTORY)
    FileUtils.rm_f Dir.glob("#{dir_path}/*")
    FileUtils.mkdir_p dir_path
  end
  module_function :clean_coverage_directory

  module CapybaraHelper
    extend ActiveSupport::Concern

    def save_js_coverage
      js_coverage = page.evaluate_script('JSON.stringify(window.__coverage__)')
      if js_coverage.present?
        time_now = Time.current
        timestamp = "#{time_now.strftime('%Y-%m-%d-%H-%M-%S.')}#{'%03d' % (time_now.usec/1000).to_i}"
        IO.write(Rails.root.join(JsCoverage::COVERAGE_DIRECTORY, "#{method_name}-#{timestamp}.json"), js_coverage)
      end
    end

    included do
      # RSpec::Rails::SystemExampleGroup で登録される after で Capybara.reset_session! されてしまうので
      # それより後にこの after を呼ぶようにする必要がある。
      # つまり RSpec.configure { |config| config.after(:each, type: :system) { page.evaluate_script(...) } } ではダメで
      # RSpec.configure { |config| config.include JsCoverage::CapybaraHelper, type: :system } にする必要がある
      after do |example|
        if example.metadata[:js] == true
          save_js_coverage
        end
      end
    end
  end
end

RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:type] == :system
      if example.metadata[:js]
        driven_by :selenium_chrome_headless, screen_size: [1400, 1400]
      else
        driven_by :rack_test
      end
    end
  end

  config.before(:suite) do
    JsCoverage.clean_coverage_directory
  end

  config.include JsCoverage::CapybaraHelper, type: :system
end
