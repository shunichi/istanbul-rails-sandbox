require 'rails_helper'

RSpec.describe 'Home', type: :system do
  it 'visit root', js: true do
    visit root_path
    expect(page).to have_content 'Hello, MyApp'
    expect(page).to have_content 'Hello React!'
  end

  # pending にしてわざとカバレッジ100%にならないようにしている
  xit 'visit bye root', js: true do
    visit root_path(greeting: 'bye')
    expect(page).to have_content 'Hello, MyApp'
    expect(page).to have_content 'Bye React!'
  end
end
