control "ec2-instance" do
  impact 0.7
  title 'Checks the compliance checks for ec2 instance'
  input('instance_ids').each do |i|
      describe aws_ec2_instance(i) do
         it { should exist }
         its('monitoring') { should eq 'state: "disabled"' }
         its('vpc_id') { should include 'vpc-' }
         its('tags') { should include(key: 'Environment', value: 'dev') }
         its('deletion_protection')     { should eq true }
         its('image_id') { should eq 'ami-27a58d5c' }
         its('tenancy') { should eq 'default' }
         its('instance_type') { should eq 't2.micro' }
         its('public_ip_address') { should be_nil }
         its('ebs_encryption') { should eq true }
         
       end
      describe aws_security_group('sg-09d4b7a5dc72d2d11') do
        it { should allow_in(port: 22, ipv4_range: '10.0.0.0/8') }
      end
  end
  describe aws_s3_bucket(input('bucket')) do
    it { should exist }
    it { should_not be_public }
    #its('tags') { should include(:Environment => 'env-name', :Name => 'bucket-name')}
    its('versioning') { should eq 'enabled' }
    its('transfer_acceleration') { should eq 'enabled' }
    its('default_encryption') { should eq 'enabled' }
    its('lifecycle') { should eq 'enabled' }
    its('logging') { should eq 'enabled' }

  end
end  
  # describe aws_ec2_instance('i-00c32c460bb0a7e0a') do
  #   its('tags') { should include(key: 'Environment', value: 'Test') }
  # end
  aws_ec2_instances.instance_ids.each do |instance_id|
    describe aws_ec2_instance(instance_id) do
      it              { should_not have_roles }
      its('instance_type') { should cmp 't2.micro' }
      its('key_name') { should cmp 'chef_inspec' }
      its('image_id') { should eq 'i-0ec7c2f30624be2f9' }
      its('tags') { should include(key: 'Environment', value: 'Test') }
    end 
  end
  # describe aws_ec2_instances do
  #   its('instance_ids.count') { should cmp 2 }
  # end
  # aws_ec2_instances.where( tags: {"Environment" => "Test"}).instance_ids.each do |id|
  #   describe aws_ec2_instance(id) do
  #     it { should be_stopped }
  #   end
  # end
  # aws_ec2_instances.where( name: "Test").instance_ids.each do |id|
  #   describe aws_ec2_instance(id) do
  #     its('role') { should eq "Cloudwatch" }
  #   end
  # end  
  


end
