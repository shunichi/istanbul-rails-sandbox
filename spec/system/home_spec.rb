require 'rails_helper'

RSpec.describe 'Home', type: :system do
  it 'visit root' do
    visit root_path
    expect(page).to have_content 'Hello, MyApp'
    expect(page).to have_content 'Hello React!'
  end
end
