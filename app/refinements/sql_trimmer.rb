module SqlTrimmer
  refine String do
    def trim
      self.gsub("\n",' ').gsub(/\s\s+/,' ').strip
    end
  end
end