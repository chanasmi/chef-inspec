control "aws-1" do
  impact 0.7
  title 'Checks the machine is running'

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
