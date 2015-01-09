require File.join(File.dirname(__FILE__), 'send_cloud','version.rb')

module SendCloud
  class EmailRecord
    attr_accessor :api_user,:api_key,:format
    require 'net/https'
    require 'uri'

    def initialize(args={:format=>'xml'})
      raise ArgumentError.new('user missing') if args[:api_user].nil?
      raise ArgumentError.new('key missing') if args[:api_key].nil?

      self.api_key=args[:api_key];self.api_user=args[:api_user];self.format=args[:format]
    end

    def method_missing(method,args)
      method_array = method.to_s.split('_')
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      if method_array.size.eql?(2)
        # 列表操作
        url = "https://sendcloud.sohu.com/webapi/list.#{method_array.last}.#{self.format}"
        raise ArgumentError.new('list address missing') if args[:address].nil?
      elsif method_array.size.eql?(3)
      #   列表中的member操作
        url = "https://sendcloud.sohu.com/webapi/list_member.#{method_array.last}.#{self.format}"
        raise ArgumentError.new('list address missing') if args[:mail_list_addr].nil?
        raise ArgumentError.new('list member address missing') if args[:member_addr].nil?
      else
         raise ArgumentError.new('no method!')
      end
      post_api(url, args)
    end
    # 给列表发送
    def send_to_list(args)
      necessary_args = [:subject,:template_invoke_name,:from,:fromname,:use_maillist,:to]
      url = "https://sendcloud.sohu.com/webapi/mail.send_template.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      post_api(url, args)
    end
    # 给一个用户发送
    def send_to_user(args)
      necessary_args = [:subject,:template_invoke_name,:from,:fromname,:substitution_vars]
      url = "https://sendcloud.sohu.com/webapi/mail.send_template.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      post_api(url, args)
    end
    # 普通发送（不使用邮件模板）
    def send_email(args)
      necessary_args = [:to,:subject,:html,:from]
      url = "https://sendcloud.sohu.com/webapi/mail.send.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key,:use_maillist=>'false'})
      post_api(url, args)
    end
    private
    # post 方式
    def post_api(api, args)
      uri = URI.parse api
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(args)
      http.request(req).body
    end
    # get 方式
    def get_api(api, args)
      uri = URI.parse api
      uri.query = args.collect { |a| "#{a[0]}=#{URI::encode(a[1].to_s)}" }.join('&')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      http.request(req).body
    end
  end
end