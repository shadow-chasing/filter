#------------------------------------------------------------------------------
# build categorys
#------------------------------------------------------------------------------
# create category first, this is because subtitles expects the foreign key to
# be added to which category it belongs, the rest are used by the cross-refernce.
#------------------------------------------------------------------------------
category_titles = ["subtitles", "filters", "wordgroups", "predicates"]

category_titles.each do |category_name|
    Category.find_or_create_by(name: category_name)
end

