class SessionLengthUI
  def self.set_length
    session_length_string = String.new
    print "Would you like to set a session expiry (y/n): "
    expiry = gets.chomp
    if expiry[0] == 'y'
      begin
        print "How many hours should the session last?: "
        hours = gets.chomp
        hours = Float(hours)
        hours = Integer(hours) if hours % 1 == 0
      rescue ArgumentError
        warn "You must enter a number."
        retry
      end
      session_length_string = "\n  session_expires_after #{hours}.hours"
    end
    return session_length_string
  end
end