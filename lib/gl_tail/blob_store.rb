class BlobStore
  @store = { }
  @used_keys = { }

  @last_prune = nil

  def self.get(key)
    @used_keys[key] = true
    return @store[key]
  end

  def self.put(key, ob)
    @store[key] = ob
    @used_keys[key] = true
  end

  def self.has(key)
    @store.include? key
  end

  def self.size
    @store.size
  end

  def self.used
    @used_keys.size
  end

  def self.mark(key)
    @used_keys[key] = true
  end 

  def self.prune(since)
    @last_prune ||= since
    if since - @last_prune >= 60000
      @store.keys.each do |k|
        unless @used_keys.include? k
          glDeleteLists(@store[k], 1)
          @store.delete k
        end
      end
      @used_keys = { }
      @last_prune = since
    end
  end

  def self.empty
 puts @store.inspect

    @store.keys.each do |k|
      glDeleteLists(@store[k], 1)
      @store.delete k
    end
    @used_keys = { }
  end
end
