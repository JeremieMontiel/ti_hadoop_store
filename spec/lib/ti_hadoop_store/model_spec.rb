# encoding: utf-8
require 'rails_helper'
require 'ti_hadoop_store'

describe TiHadoopStore::Model do

  before do
    @connection = double('connection')
    allow(@connection).to receive(:close)
    allow(TiHadoopStore::Model).to receive(:connect!).and_return(@connection)
    allow(TiHadoopStore::Model).to receive(:database) { 'development' }
    allow(TiHadoopStore::Model).to receive(:timeout) { 1000 }
  end

  after do
    TiHadoopStore::Model.close
  end

  it 'checks if a table exists in the database' do
    expected_query_a_table = "SHOW TABLES IN development LIKE 'a_table'"
    expected_query_no_table = "SHOW TABLES IN development LIKE 'no_table'"

    expect(@connection).to \
      receive(:query).with(expected_query_a_table)
                     .and_return([{ name: 'a_table' }])
    expect(@connection).to receive(:close)
    result = TiHadoopStore::Model.table_exists?('a_table')
    expect(result).to eq(true)

    expect(@connection).to \
      receive(:query).with(expected_query_no_table).and_return([])
    expect(@connection).to receive(:close)
    result = TiHadoopStore::Model.table_exists?('no_table')
    expect(result).to eq(false)
  end

  describe 'timeout error' do
    it 'raise error when responds too late, not otherwise' do
      query_example = 'select * from development.client;'

      expect(TiHadoopStore::Model).to receive(:timeout).and_return(1000)
      expect(@connection).to receive(:query).with(query_example).and_return([])
      result = TiHadoopStore::Model.query(query_example)
      expect(result).to eql([])

      expect(TiHadoopStore::Model).to receive(:timeout).and_return(1000)
      expect(@connection).to receive(:query).with(query_example) do
        sleep(2)
        []
      end
      expect do
        TiHadoopStore::Model.query(query_example)
      end.to raise_error(Timeout::Error)
    end

    it 'no timeout when value is set to 0' do
      expect(TiHadoopStore::Model).to receive(:timeout).and_return(0)
      expect(@connection).to receive(:query).with('') do
        sleep(1)
        []
      end
      result = TiHadoopStore::Model.query('')
      expect(result).to eql([])
    end

    it 'table_exists? should close connection on timeout error' do
      expected_query_a_table = "SHOW TABLES IN development LIKE 'a_table'"

      expect(TiHadoopStore::Model).to receive(:timeout).and_return(1000)
      expect(@connection).to receive(:query).with(expected_query_a_table) do
        sleep(2)
        [{ name: 'a_table' }]
      end
      expect(@connection).to receive(:close)
      expect do
        TiHadoopStore::Model.table_exists?('a_table')
      end.to raise_error(Timeout::Error)
    end
  end
end
