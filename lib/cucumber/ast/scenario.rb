module Cucumber
  module Ast
    class Scenario
      def initialize(step_mother, comment, tags, name, step_names_and_multiline_args)
        @step_mother, @comment, @tags, @name = step_mother, comment, tags, name
        @steps = step_names_and_multiline_args.map{|saia| Step.new(self, nil, *saia)}
      end

      def accept(visitor)
        visitor.visit_comment(@comment)
        visitor.visit_tags(@tags)
        visitor.visit_scenario_name(@name)
        @step_mother.world(self) do |world|
          previous = :passed
          @steps.each do |step|
            previous = step.execute(world, previous)
            visitor.visit_step(step)
          end
        end
      end

      def step_invocation(step_name, world)
        @step_mother.step_invocation(step_name, world)
      end

      def max_step_length
        @steps.map{|step| step.text_length}.max
      end
    end
  end
end
