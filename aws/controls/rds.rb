control "aws-2" do
    impact 0.7
    title 'Checks the machine is running'
    describe aws_rds_instance('database-1') do
      it { should exist }
      # its ('engine')         { should eq 'mysql' }
      # its ('engine_version') { should eq '5.7.22' }
      # its ('storage_type')      { should eq 'SSD' }
      # its ('allocated_storage') { should eq 10 }
      # its ('master_username')   { should eq 'admin' }
      # its ('db_instance_class') { should eq 'db.t2.micro' }
    end
    
    # describe aws_rds_instance(db_instance_identifier: 'database-1') do
    #   its ('publicly_accessible')      { should eq false }
    #   its ('multi_az')                 { should eq false }  
    # end
    
    aws_rds_instances.db_instance_identifiers.each do |db_instance_identifier|
      describe aws_rds_instance(db_instance_identifier) do
      its ('publicly_accessible')       { should eq false }  #Rule1
      its ('multi_az')                  { should eq false }  #Rule2
      its('storage_encrypted')          { should eq false }    #Rule4
      its('backup_retention_period')    { should be > 0 }    #Rule6
      #its('tags')                       { should include(:Environment => 'test')}  #Rule11
      its('tags') { should include("Environment" => "test") }
      its('enhanced_monitoring_resource_arn')        { should match /arn:aws:logs/ }    #Rule12
      end
    end
    
    #Rule 5  default (sg-7e03de1b)
    describe aws_security_group('sg-c643c8e8') do
      it { should exist }
    end
    
    describe aws_security_group('sg-c643c8e8') do
      its('outbound_rules') { should_not allow_in(ip_ranges: '0.0.0.0/0') }
      it { should allow_in(ipv4_range: ["10.1.2.0/24", "10.3.2.0/24"], protocol: 'all') }
      it { should allow_in(port: 22, ipv4_range: '10.5.0.0/16') }
      it { should_not allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
      it { should allow_in_only(port: 443, security_group: "sg-056c25048f483ef37") }
    end
    
    #Rule9
    describe aws_iam_password_policy do
      it                             { should require_uppercase_characters }
      it                             { should require_lowercase_characters }
      it                             { should require_numbers }
      its('minimum_password_length') { should be > 5 }
      its('max_password_age_in_days') {should eq 30}
      it                             { should allow_users_to_change_password }
    end
    #Rule7 
    #Commented as I don't have the policy name
    describe aws_iam_policy(policy_name: 'AmazonRDSFullAccess') do
      # it { should have_statement(Action: 'rds:ReadOnly', Effect: 'allow') }
      # it { should_not have_statement(Action: 'srds3:*') }
      # it { should_not have_statement(NotAction: 'iam:*') }
      it { should have_statement(Action: 'rds:*') }
    end
     #Rule13
    #  describe aws_config_recorder do
    #   it { should be_recording }
    #   its('resource_types') { should include 'AWS::RDS::DBInstance' }
    # end
  end 
    
  
  
