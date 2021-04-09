require_relative 'helper'

require 'protocol/redis/methods/connection'

RSpec.describe Protocol::Redis::Methods::Connection do
	let(:object) {Object.including(Protocol::Redis::Methods::Connection).new}

	describe '#auth' do
		it 'generates correct arguments for password' do
			expect(object).to receive(:call).with('AUTH', 'hunter2').and_return("OK")
			
			response = object.auth("hunter2")
			expect(response).to be_truthy
		end
		
		it 'generates correct arguments for username & password' do
			expect(object).to receive(:call).with('AUTH', 'AzureDiamond', 'hunter2').and_return("OK")
			
			response = object.auth("AzureDiamond", "hunter2")
			expect(response).to be_truthy
		end
	end
end
