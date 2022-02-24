require 'rails_helper'

RSpec.describe 'secure cookies' do
  it 'flags all cookies sent by the application as Secure, HttpOnly, and SameSite=Lax' do
    get root_url
    cookie_count = response.headers['Set-Cookie'].split("\n").count

    expect(response.headers['Set-Cookie'].scan('; Secure').size).to eq(cookie_count)
    expect(response.headers['Set-Cookie'].scan('; HttpOnly').size).to eq(cookie_count)
    expect(response.headers['Set-Cookie'].scan('; SameSite=Lax').size).to eq(cookie_count)
  end
end
