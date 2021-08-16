require_relative '../../db/db_connector'

RSpec.describe '.create_db_client' do
  let(:hostname) { "hostname" }
  let(:username) { "username" }
  let(:password) { "password" }
  let(:database) { "database" }
  let(:params) {
    {
      :host => hostname,
      :username => username,
      :password => password,
      :database => database
    }
  }
  let(:mysql_client) { double }

  before do
    allow(ENV).to receive(:[]).with("HOST").and_return(hostname)
    allow(ENV).to receive(:[]).with("DB_USERNAME").and_return(username)
    allow(ENV).to receive(:[]).with("DB_PASSWORD").and_return(password)
    allow(ENV).to receive(:[]).with("DB_DATABASE").and_return(database)

    allow(Mysql2::Client).to receive(:new).once
      .with(params).and_return(mysql_client)
  end

  it 'returns db client' do
    client = create_db_client
    expect(client).to eq(mysql_client)
  end
end
