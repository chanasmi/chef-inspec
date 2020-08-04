control "ec2-instance" do
  impact 0.7
  title 'Checks the compliance checks for ec2 instance'
  input('instance_ids').each do |i|
      describe aws_ec2_instance(i) do
         it { should exist }
         its('vpc_id') { should include 'vpc-' }
          its('tags') { should include(key: 'Environment', value: 'dev') }
        
          its('image_id') { should eq input('image_id') }
        
          its('instance_type') { should eq input('instance_type') }
          its('public_ip_address') { should be_nil }
        
      end
    
      describe aws_security_group(input('security_group')) do
        it { should allow_in(port: 22, ipv4_range: '10.0.0.0/8') }
      end
      describe aws_ebs_volume(name: input('volume_name')) do
        it { should be_encrypted }
      end
      describe aws_s3_bucket(input('bucket')) do
        it { should exist }
        it { should_not be_public }
        its('tags') { should include(:Environment => 'env-name', :Name => 'bucket-name')}
      
      #   its('get_bucket_accelerate_configuration') { should eq 'enabled' }
      
         it { should have_default_encryption_enabled }
         #its('lifecycle') { should eq 'enabled' }
         it { should have_lifecycle_enabled }
         it { should have_object_level_logging_enabled }
         it { should have_secure_transport_enabled }
         it { should have_access_logging_enabled }
         it { should have_versioning_enabled }
         its('bucket_policy') { should_not be_empty }
    
      end
  end
#   sql = postgres_session('postgres', 'testdb123', 'database-2.cp1misqgyxxe.us-east-1.rds.amazonaws.com')

#   describe sql.query('SELECT 1;', ['testdb']) do
#     its('output') { should eq('1') }
#   end
# end  
#   # describe aws_rds_cluster('database-2') do
#   #   it { should exist }
#   # end
  # describe etc_group do
  #   its('users') { should include 'ec2-user' }
  # end
  # describe bash('cat /etc/redhat-release') do
  #   its('stdout') { should include '8.1' }
  # end
end
