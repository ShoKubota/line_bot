class LinebotController < ApplicationController
    require 'line/bot'  # gem 'line-bot-api'

    # callbackアクションのCSRFトークン認証を無効
    protect_from_forgery :except => [:callback]

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["
c55544ad5dfa4d771e55806de2c40d8a"]
        config.channel_token = ENV["s3mAbP5cWevoXpOQWi/3PSHyteez3bbAg+mieq/7i6gL8tefctheyPbSNSTlvp7QYz7VIpEG1i1Gd/23IAsO2CkBi92rJ9YoahhDI15LirMTHHBxjr4HbF990aADKrR0Fk4VDzJEEWE3kQHWOWurUQdB04t89/1O/w1cDnyilFU="]
      }
    end

    def callback
      body = request.body.read

      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        head :bad_request
      end

      events = client.parse_events_from(body)

      events.each { |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: event.message['text']
            }
            client.reply_message(event['replyToken'], message)
          end
        end
      }
      head :ok
    end
end