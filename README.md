# SendCloud

 Send email by SendCloud

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'send_cloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install send_cloud

## Usage

#notes:

#initialize
require 'lib/send_cloud'
支持json和xml两种格式，默认为xml
email = SendCloud::EmailRecord.new({:api_user=>'your_name',:api_key=>'your_key',:format=>'json'})
# create a list
email.list_create({:address=>'test@edm1.com'})
result:
<?xml version="1.0" encoding="UTF-8"?>
<result><message>success</message><list><create_at>2015-01-04 10:52:59</create_at><address>test@edm1.com</address><members_count>0</members_count><description /><name /></list></result>
# search a list
email.list_get({:address=>'test@edm1.com,:start=>'',:limit=>''})
# delete a list
email.list_delete({:address=>'test@edm1.com'})
# add user to list
support add users once time
email.list_member_add({:mail_list_addr=>'test@edm1.com',:member_addr=>'john.li@rccchina.com;tony.liu@rccchina.com',
                       :name=>'john.li;tony.liu',:vars=>'{i:1};{i:2}'})# search user from list
# get user from list
email.list_member_get({:mail_list_addr=>'test@rccchina.com', :member_addr=>'tony.liu@rccchina.com', :start=>"", :limit=>""})
# delete user from list
email.list_member_delete({:mail_list_addr=>'test@edm1.com',:member_addr=>'john.li@rccchina.com',:name=>'john.li'})
# send to one user
substitution_vars = "{'to':['john.li@rccchina.com'], 'sub' : { '%name%' : ['约翰'], '%i%' : ['1']}}"
email.send_to_user({:subject => 'your subject', :template_invoke_name => 'gx_20131227', :from => 'RCCChina <system@rccchina.com>', :fromname => 'RCCChina', :substitution_vars => substitution_vars})
# send to list
email.send_to_list({:subject => 'your subject', :template_invoke_name => 'gx_20131227', :from => 'RCCChina <system@rccchina.com>', :fromname => 'RCCChina', :use_maillist => true, :to => 'test@edm1.com'})
# 普通发送
email.send_email({:subject=>'普通发送',:html=>'测试普通发送',:from=>'tony.liu@rccchina.com',:to=>'john.li@rccchina.com'})
# api参考:
http://sendcloud.sohu.com/doc/apiGuide.html#apiSend
## Contributing

1. Fork it ( https://github.com/[my-github-username]/send_cloud/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
