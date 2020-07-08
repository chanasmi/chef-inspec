control "aws-1" do
  impact 0.7
  title 'Checks the tags for EC2 instance'

  describe aws_ec2_instance('i-0c0284127b8c2e752') do
    its('tags') { should include(key: 'Environment', value: 'Test') }
  end
end

