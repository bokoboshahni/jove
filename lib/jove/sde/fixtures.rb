# frozen_string_literal: true

module Jove
  module SDE
    # :nocov:
    class Fixtures # rubocop:disable Metrics/ClassLength
      TRUNCATE_FIXTURES = %w[bsd fsd].freeze

      COPY_FIXTURES = %w[
        fsd/landmarks/landmarks.staticdata
        fsd/translationLanguages.yaml
        fsd/universe/abyssal/12000001/region.staticdata
        fsd/universe/abyssal/12000001/22000001/constellation.staticdata
        fsd/universe/abyssal/12000001/22000001/32000001/solarsystem.staticdata
        fsd/universe/eve/Devoid/region.staticdata
        fsd/universe/eve/Devoid/Semou/constellation.staticdata
        fsd/universe/eve/Devoid/Semou/Arzad/solarsystem.staticdata
        fsd/universe/eve/Lonetrek/region.staticdata
        fsd/universe/eve/Lonetrek/Umamon/constellation.staticdata
        fsd/universe/eve/Lonetrek/Umamon/Saranen/solarsystem.staticdata
        fsd/universe/eve/TheForge/Kimotoro
        fsd/universe/eve/TheForge/region.staticdata
        fsd/universe/eve/OuterRing/region.staticdata
        fsd/universe/eve/OuterRing/Heart/constellation.staticdata
        fsd/universe/eve/OuterRing/Heart/4C-B7X/solarsystem.staticdata
        fsd/universe/eve/Pochven/region.staticdata
        fsd/universe/eve/Pochven/KraiPerun/constellation.staticdata
        fsd/universe/eve/Pochven/KraiPerun/Ignebaener/solarsystem.staticdata
        fsd/universe/eve/PureBlind/region.staticdata
        fsd/universe/eve/PureBlind/304Z-R/constellation.staticdata
        fsd/universe/eve/PureBlind/304Z-R/F-NMX6/solarsystem.staticdata
        fsd/universe/void/VR-01/region.staticdata
        fsd/universe/void/VR-01/VC-001/constellation.staticdata
        fsd/universe/void/VR-01/VC-001/V-001/solarsystem.staticdata
        fsd/universe/wormhole/A-R00001/region.staticdata
        fsd/universe/wormhole/A-R00001/A-C00311/constellation.staticdata
        fsd/universe/wormhole/A-R00001/A-C00311/J100744/solarsystem.staticdata
        fsd/universe/wormhole/A-R00001/A-C00312/constellation.staticdata
        fsd/universe/wormhole/A-R00001/A-C00312/J105711/solarsystem.staticdata
      ].freeze

      def generate
        FileUtils.rm_rf(Rails.root.join('spec/fixtures/sde'))
        TRUNCATE_FIXTURES.each { |f| truncate_fixtures(f) }
        COPY_FIXTURES.each { |f| copy_fixtures(f) }
        write_inv_names
      end

      private

      def write_inv_names # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
        names = YAML.load_file(Rails.root.join('tmp/sde/bsd/invNames.yaml'))
        fixture_name_ids = []
        fixtures = Dir[Rails.root.join('spec/fixtures/sde/**/*.{staticdata,yaml}')]
        Parallel.each(fixtures, in_threads: Etc.nprocessors * 2) do |fixture|
          fixture_name_ids.push(
            *File.readlines(fixture).grep(/\A(\s+)?(\d+:|\w+ID:|id:)/)
                                .map { |l| l.gsub(/(\w+ID|id):/, '') }
                                .map { |l| l.gsub(/:/, '') }
                                .map(&:chomp)
                                .map(&:strip)
                                .map(&:to_i)
                                .uniq
                                .sort
          )
        end
        fixture_name_ids.uniq!
        fixture_names = names.select { |n| fixture_name_ids.include?(n['itemID']) }
        File.write(Rails.root.join('spec/fixtures/sde/bsd/invNames.yaml'), fixture_names.to_yaml)

        puts 'Wrote all names for IDs found in spec/fixtures/sde to spec/fixtures/sde/bsd/invNames.yaml'
      end

      def copy_fixtures(path)
        sde_path = Rails.root.join('tmp/sde', path)
        relative_path = Pathname.new(sde_path).relative_path_from(Rails.root.join('tmp/sde')).to_s
        dest_path = Rails.root.join('spec/fixtures/sde', relative_path)
        FileUtils.mkdir_p(File.dirname(dest_path))
        FileUtils.cp_r(sde_path, dest_path)

        puts "Copied #{sde_path} to #{dest_path}"
      end

      def truncate_fixtures(dir) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        Dir.glob(Rails.root.join('tmp/sde', "#{dir}/*.{staticdata,yaml}")).each do |filename|
          next if filename.ends_with?('translationLanguages.yaml')

          data = YAML.load_file(filename)

          fixtures =
            if data.is_a?(Hash)
              schema = discover_schema(data.values)
              fixture_ids = []
              schema[:properties].each_key do |prop|
                fixture_ids.push(*data.select { |_id, record| record.key?(prop) }.keys.take(10))
              end

              data.slice(*fixture_ids)
            else
              schema = discover_schema(data)
              fixtures = Set.new
              schema[:properties].each_key do |prop|
                fixtures.merge(data.select { |record| record.key?(prop) }.take(50))
              end
              fixtures.to_a
            end

          fixture_file = Rails.root.join("spec/fixtures/sde/#{dir}/#{File.basename(filename)}")
          FileUtils.mkdir_p(File.dirname(fixture_file))
          File.write(fixture_file, fixtures.to_yaml)
          puts "Wrote #{fixture_file} from #{filename}"
        end
      end

      def discover_schema(data) # rubocop:disable Metrics/MethodLength
        schema = {}
        schema[:properties] = {}

        data.each do |sample|
          sample.each do |(key, value)|
            schema[:properties][key] = case value
                                       when Array
                                         # TODO: Recursively discover schema
                                         { type: 'Array', item: value.first.class.name }
                                       when Hash
                                         # TODO: Recursively discover schema
                                         { type: 'Hash' }
                                       else
                                         { type: value.class.name }
                                       end
          end
        end

        schema
      end
    end
  end
end
