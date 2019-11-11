abstract class Scouter::View
  @@cache = {} of String => View

  abstract def paint(painter : TUI::Painter)

  abstract def parent : View

  abstract def focus : View

  def next : Bool
    false
  end

  def previous : Bool
    false
  end

  # Resolve a path to a specific view
  def self.resolve(path) : View
    cache_val = cached(path)
    return cache_val if cache_val
    begin
      if ::File.directory?(path); View::Dir.new(path)
      elsif ::File.file?(path); View::File.new(path)
      else
        TUI.logger.info "Unrecognised FS type: #{path} #{::File.info?(path).try &.type}"
          View::Unknown.new(path)
      end
    rescue ex : Errno
      View::Error.new(path, ex)
    end
  end

  protected def self.cached(path) : View?
    @@cache[path]?
  end

  protected def self.cache
    @@cache
  end
end

require "./view/*"
