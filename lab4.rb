require 'colored'

class Device

  class << self

    def run
      get_constants

      puts 'Processing...'.blue

      queue = 0
      channel_state = 0
      current_time = 0
      current_request = 0
      input_stream = create_input_stream


      #=================================
      count_cycles = 0
      count_queue = 0
      count_queue_system = 0
      all_queue = 0
      request_in_queue = 0
      request_in_sys = 0
      #=================================

      file = File.open('lab4_states.txt', 'w')

      while current_request < input_stream.size
        file.puts "#{channel_state}|#{queue}"
        file.puts '='*10

        count_cycles += 1
        all_queue += queue
        count_queue += (queue - channel_state)
        count_queue_system += (queue + channel_state)
        request_in_queue += 1 if queue > 1
        request_in_sys += 1 if queue > 0 || channel_state == 1

        if input_stream[current_request] < current_time
          current_request += 1
          queue += 1
          next
        end

        if queue > 0 && channel_state == 0
          current_time += -Math.log(rand)/@t
          channel_state = 1
          next
        end

        if queue > 0 && channel_state == 1
          current_time += -Math.log(rand)/@m
          channel_state = 0 if queue == 1
          queue -= 1
          next
        end

        if queue == 0
          current_time = input_stream[current_request] + -Math.log(rand)/@m #???!!
          current_request += 1
          next
        end
      end

      puts '='.blue * 40
      puts 'RESULT:'.blue
      puts 'average number of requests in queue'.red + ' = ' + "#{count_queue/count_cycles}".green
      puts 'average number of requests in sys'.red + ' = ' + "#{count_queue_system/count_cycles}".green
      puts 'average time of requests in queue'.red + ' = ' + "#{(request_in_queue/count_cycles.to_f).round(3)}".green
      puts 'average time of requests in sys'.red + ' = ' + "#{(request_in_sys/count_cycles.to_f).round(3)}".green
      puts '='.blue * 40
    end

    private

    def create_input_stream
      time = 0
      input_stream = []
      input_stream.push time
      @number_requests.times do
        time += -Math.log(rand)/@l
        input_stream.push time
      end

      input_stream
    end

    def get_constants
      @l = ARGV[0].to_f > 0 ? ARGV[0].to_f : 1.5
      @m = ARGV[1].to_f > 0 ? ARGV[1].to_f : 2.0
      @t = ARGV[2].to_f > 0 ? ARGV[2].to_f : 0.4
      @number_requests = ARGV[3].to_i === 1..1e7 ? ARGV[3].to_i : 100_000


      puts 'l'.red + ' = '+ "#{@l}".green
      puts 'm'.red + ' = ' + "#{@m}".green
      puts 't'.red + ' = ' + "#{@t}".green
      puts 'number of requests'.red + ' = ' + "#{@number_requests}".green
    end

  end

end

Device.run
