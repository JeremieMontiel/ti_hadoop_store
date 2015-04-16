# encoding: utf-8
require 'rails_helper'
require 'ti_hadoop_store'

describe TiHadoopStore do
  it 'loads the Rails database configuration' do
    expect(TiHadoopStore::Config.databases).to include('test_hadoop')
  end

  it 'connects to the Rails logger' do
    expect(TiHadoopStore::Config.logger).to be(Rails.logger)
  end
end
