# RailRoad - RoR diagrams generator
# http://railroad.rubyforge.org
#
# Copyright 2007-2008 - Javier Smaldone (http://www.smaldone.com.ar)
# See COPYING for more details

require 'railroad/diagram_graph'

# Root class for RailRoad diagrams
class AppDiagram

  def initialize(options)
    @options = options
    @graph = DiagramGraph.new
    @graph.show_label = @options.label

    STDERR.print "Loading application environment\n" if @options.verbose
    load_environment

    STDERR.print "Loading application classes\n" if @options.verbose
    load_classes
  end

  # Print diagram
  def print
    if @options.output
      old_stdout = STDOUT.dup
      begin
        STDOUT.reopen(@options.output)
      rescue
        STDERR.print "Error: Cannot write diagram to #{@options.output}\n\n"
        exit 2
      end
    end
    
    if @options.xmi 
        STDERR.print "Generating XMI diagram\n" if @options.verbose
    	STDOUT.print @graph.to_xmi
    else
        STDERR.print "Generating DOT graph\n" if @options.verbose
        STDOUT.print @graph.to_dot 
    end

    if @options.output
      STDOUT.reopen(old_stdout)
    end
  end # print

  private 

  # Prevents Rails application from writing to STDOUT
  def disable_stdout
    @old_stdout = STDOUT.dup
    STDOUT.reopen(RUBY_PLATFORM =~ /mswin/ ? "NUL" : "/dev/null")
  end

  # Restore STDOUT  
  def enable_stdout
    STDOUT.reopen(@old_stdout)
  end


  # Print error when loading Rails application
  def print_error(type)
    STDERR.print "Error loading #{type}.\n  (Are you running " +
                 "#{APP_NAME} on the aplication's root directory?)\n\n"
  end

  # Load Rails application's environment
  def load_environment
    begin
      disable_stdout
      require "config/environment"
      enable_stdout
    rescue LoadError
      enable_stdout
      print_error "application environment"
      raise
    end
  end

  # Extract class name from filename
  def extract_class_name(filename)
    #filename.split('/')[2..-1].join('/').split('.').first.camelize
    # Fixed by patch from ticket #12742
    #
    # Return a namespaced path for a model if we can find one
    # 1) Get the filename without the ruby extension
    name = filename.chomp(".rb")
    # 2) Split on the directory splitter (/, windows guys can eat shit and die)
    name_arr = name.split("/")
    # 3) Find where models shows up in the hierarchy...
    models_index = name_arr.index("models")
    if(models_index)
      # 4) ...and only get the bits after that
      namespace_path = name_arr[models_index + 1..-1]
      # 5) Now try to get a constant name out of that
      return namespace_path.map(&:camelize).join("::").camelize
    end

    # This doesn't support namespaces at all, but I'll fall back to it if namespacing doesn't work
    File.basename(filename).chomp(".rb").camelize
  end

end # class AppDiagram
