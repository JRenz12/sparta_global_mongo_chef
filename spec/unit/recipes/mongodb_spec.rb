require 'spec_helper'

describe 'nodemongo::mongodb' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do

      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'runs apt get update' do
      expect( chef_run ).to update_apt_update 'update'
    end

    it 'should add mongodb to the source list' do
      expect( chef_run ).to add_apt_repository 'mongodb-org'
    end

    it 'should install mongodb and upgrade' do
      expect( chef_run ).to upgrade_package 'mongodb-org'
    end

    it 'should enable mongod service' do
      expect( chef_run ).to enable_service 'mongod'
    end

    it 'should start mongod service' do
      expect( chef_run ).to start_service 'mongod'
    end

    it 'should update the mongo service config' do
      expect( chef_run ).to create_template('/lib/systemd/system/mongod.service').with(source: 'mongod.service.erb')
      template = chef_run.template('/lib/systemd/system/mongod.service')
      expect(template).to notify('service[mongod]')
    end

    it 'should update the mongod at config' do
      expect( chef_run ).to create_template('/etc/mongod.conf').with_variables(port: 27017, ip_addresses: ['0.0.0.0'])
      template = chef_run.template('/etc/mongod.conf')
      expect(template).to notify('service[mongod]')
    end

      at_exit { ChefSpec::Coverage.report! }
  end
end
