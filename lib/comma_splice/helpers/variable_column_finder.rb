# frozen_string_literal: true

module CommaSplice
  # Given a header line and some value lines this will try to figure out the columns
  # where it's likely an error might be.

  # Columns on the left and right bounds will be ignored if each line has the same length

  # For example, the following CSV will evaluate with @start_column = 5 and @end_column = -4
  # since in this example playid, playtime, genre, and timestamp are all non-variable on the left,
  # and prepost, programtype, iswebcast, and isrequest are non-variable on the right

  #     playid,playtype,genre,timestamp,artist,title,albumtitle,label,prepost,programtype,iswebcast,isrequest
  #     17385098,,,01-27-2019 @ 13:58:00,Niney & Soul Syndicate,So Long Dub,Dub Box Set Vol. 2,Trojan,post,live,y,
  #     17385097,,,01-27-2019 @ 13:57:00,King Tubby,Love Thy Neighbor,Jesus Dread,Blood & Fire,post,live,y,
  #     17385096,,,01-27-2019 @ 13:53:00,King Tubby / The Aggrovators,Declaration Of Dub,Dub From The Roots,Charly,post,live,y,
  #     17385095,,,01-27-2019 @ 13:50:00,Harry Mudie / King Tubby,Dub With A Difference,In Dub Conference Vol. 1,Moodisc,post,live,y,
  #     17385094,,,01-27-2019 @ 13:47:00,KIng Tubby Meets The Upsetter,King And The Upsetter At Spanish Town,KIng Tubby Meets The Upsetter,Celluloid,post,live,y,

  class VariableColumnFinder
    attr_reader :start_column, :end_column, :separator

    def initialize(header_line, value_lines, separator = ',')
      @values = value_lines
      @header = header_line
      @separator = separator
      find_variable_column_boundaries
    end

    def find_variable_column_boundaries
      # Now given both of these, we can eliminate some columns on the left and right
      variables = left_to_right_index.zip(right_to_left_index).map do |pair|
        pair == [false, false]
      end

      start_column = variables.find_index(true)
      end_column = variables.reverse.find_index(true)

      @start_column = start_column || 0
      @end_column = (end_column || 1) * -1
    end

    private

    def left_to_right_index
      left_to_right_index = []
      @header.split(@separator).size.times do |time|
        left_to_right_index.push(@values.map do |value_line|
          value_line.split(@separator)[time].to_s.size
        end.uniq.size == 1)
      end

      left_to_right_index
    end

    def right_to_left_index
      right_to_left_index = []
      @header.split(@separator).size.times do |time|
        right_to_left_index.unshift(@values.map do |value_line|
          value_line.split(@separator)[-time].to_s.size
        end.uniq.size == 1)
      end

      right_to_left_index
    end
  end
end
