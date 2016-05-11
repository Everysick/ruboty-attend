module Ruboty
  module Handlers
    class Attendance < Base
      NAMESPACE = 'ruboty-attend'
      ROLE = { attend: 'Attend', absent: 'Absent' }

      on(
        /create_attendance\s?(?<desc>.+?)\z/,
        name: 'create_attendance',
        description: 'create new attendance'
      )

      on(
        /attend_status\s?(?<ch>(\d)+?)\z/,
        name: 'attend_status',
        description: 'get state of channel'
      )

      on(
        /close_attendance\s?(?<ch>(\d)+?)\z/,
        name: 'close_attendance',
        description: 'close attendance'
      )

      on(
        /all_attendance\z/,
        name: "all_attendance",
        description: 'show all attendance'
      )

      on(
        /attend\s?(?<ch>(\d)+?)\z/,
        name: 'attend_user',
        description: 'attend target channel event'
      )

      on(
        /absent\s?(?<ch>(\d)+?)\z/,
        name: 'absent_user',
        description: 'absent target channel event'
      )

      def create_attendance(message)
        begin
          new_ch_num = create_new_chx
          attend_table[new_ch_num] = {}
          attend_ch[new_ch_num] = message[:desc]
          message.reply("Create new channel event!\n Ch.No. -> #{new_ch_num}, Detail -> #{attend_ch[new_ch_num]}")
        rescue => e
          message.reply(e.message)
        end
      end

      def attend_status(message)
        begin
          current_ch = message[:ch].to_i
          message.reply(current_message(current_ch))
        rescue => e
          message.reply(e.message)
        end
      end

      def close_attendance(message)
        begin
          current_ch = message[:ch].to_i
          result_message = current_message(current_ch)
          attend_table.delete(current_ch)
          attend_ch.delete(current_ch)
          message.reply(result_message)
        rescue => e
          message.reply(e.message)
        end
      end

      def all_attendance(message)
        begin
          result_message = "All channel event is here\n"
          attend_ch.keys.each do |ch_num|
            result_message += current_message(ch_num)
          end
          message.reply(result_message)
        rescue => e
          message.reply(e.message)
        end
      end

      def attend_user(message)
        begin
          message.reply(divide_user(:attend, message))
        rescue => e
          message.reply(e.message)
        end
      end

      def absent_user(message)
        begin
          message.reply(divide_user(:absent, message))
        rescue => e
          message.reply(e.message)
        end
      end

      private

      def divide_user(state, message)
        current_ch = message[:ch].to_i

        if ch_exist?(current_ch)
          return "Ch.#{current_ch} does not exist."
        end

        attend_table[current_ch].merge!({ message.from_name => state })
        "#{attend_ch[current_ch]}に#{ROLE[state]}っ！"
      end

      def ch_exist?(ch_num)
        attend_table[ch_num].nil?
      end

      def current_message(current_ch)
        if ch_exist?(current_ch)
          return "Ch.#{current_ch} does not exist."
        end

        attend_counter = 0
        ret_message = "[Ch.#{current_ch}, #{attend_ch[current_ch]}]\n"
        attend_table[current_ch].each do |key, val|
          ret_message += "#{key.to_s}: #{ROLE[val]}\n"
          attend_counter += 1 if val == :attend
        end

        ret_message + "num of attend user: #{attend_counter}\n"
      end

      def attend_table
        robot.brain.data[NAMESPACE + "_table"] ||= {}
      end

      def attend_ch
        robot.brain.data[NAMESPACE + "_ch"] ||= {}
      end

      def create_new_ch
        (1..100).to_a.select {|num| !attend_ch.keys.include?(num)}.first
      end
    end
  end
end
