# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2021-2023, by Samuel Williams.

require 'methods_context'
require 'protocol/redis/methods/connection'

describe Protocol::Redis::Methods::Connection do
	include_context MethodsContext, Protocol::Redis::Methods::Connection
	
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
