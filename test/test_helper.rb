require 'rubygems'

require 'test/unit'
require 'activerecord'
require 'active_record/fixtures'
require 'action_controller'
#require 'action_controller/test_case'
require 'action_controller/test_process'

ROOT       = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'conventionally_scoped_names')

require File.join(ROOT, 'lib', 'conventionally_scoped_names.rb')

FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures")

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config[ENV['RAILS_ENV'] || 'test'])

def load_test_fixtures
  Fixtures.create_fixtures(FIXTURES_DIR, ["posts"])
  Fixtures.instantiate_all_loaded_fixtures(self)
end

def delete_test_fixtures
  Fixtures.all_loaded_fixtures.each_value(&:delete_existing_fixtures)
end

def load_schema
  load(File.dirname(__FILE__) + "/schema.rb")

  Object.send(:remove_const, "Post") rescue nil
  Object.const_set("Post", Class.new(ActiveRecord::Base))
  Post.class_eval do
    named_scope :published, :conditions => {:status => 'published'}
    named_scope :draft,     :conditions => {:status => 'draft'}
    named_scope :archived,  :conditions => {:status => 'archived'}

    named_scope :published_or_draft, :conditions => ["status in ('published', 'draft')"]

    named_scope :last_month, lambda { {:conditions => ["last_modified > ?", 1.month.ago.to_date.to_s]} }
    named_scope :last_year,  lambda { {:conditions => ["last_modified > ?", 1.year.ago]} }
    named_scope :this_month, lambda { {:conditions => ["last_modified > ?", Time.now.beginning_of_month.to_date.to_s]}}

    named_scope :sort_by_title,   :order => "title DESC"
    named_scope :sort_by_updated, :order => "last_modified DESC"

    named_scope :with_title, lambda { |*args| {:conditions => ["title like ?", '%'+args[0]+'%']} }

    def published?; status == "published" end
    def draft?;     status == "draft"     end
    def archived?;  status == "archived"  end
  end

end
