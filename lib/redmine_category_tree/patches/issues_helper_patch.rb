module RedmineCategoryTree
	module Patches
		module IssuesHelperPatch
			def self.prepended(base)
				base.class_eval do
				  include RedmineCategoryTree::IssueCategoryHelper
				end
			end

			def find_name_by_reflection(field, id)
				return nil if id.blank?

				@detail_value_name_by_reflection ||= Hash.new do |hash, key|
					association = Issue.reflect_on_association(key.first.to_sym)
					name = nil
					if association
						record = association.klass.find_by_id(key.last)
						if (record && !record.is_a?(Project)) || (record.is_a?(Project) && record.visible?)
							if key.first == 'category'
								name = render_issue_category_with_tree_inline(record).force_encoding('UTF-8')
							else
								name = record.name.force_encoding('UTF-8')
							end
						end
					end
					hash[key] = name
				end
				@detail_value_name_by_reflection[[field, id]]
			end
		end
	end
end
