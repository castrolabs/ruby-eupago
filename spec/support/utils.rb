module Utils
  def self.deep_merge(hash1, hash2)
    hash1.merge(hash2) do |_key, v1, v2|
      if v1.is_a?(Hash) && v2.is_a?(Hash)
        deep_merge(v1, v2)
      else
        v2
      end
    end
  end
end
