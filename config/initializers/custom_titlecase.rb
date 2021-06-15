class String
    def custom_titlecase
        self.gsub(/\b\w/) { |w| w.upcase }
    end
end