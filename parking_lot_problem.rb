class ParkingSystem
    attr_reader :available_slots, :all_vehicles

    def initialize(small, medium, large)
        @available_slots = {"small"=> small, "medium"=> medium, "large"=> large}
        @all_vehicles = {}
        @small_in_medium_slot = {}
        @small_in_large_slot = {}
        @medium_in_large_slot = {}
    end

    def admit_the_vehicle(license_plate_number, vehicle_slot_size)
        if !@all_vehicles.has_key?(license_plate_number)
            if vehicle_slot_size == "small"
                if slot_availability("small")
                    park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "small")
                elsif slot_availability("medium")
                    park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "medium")
                    @small_in_medium_slot.store(license_plate_number, vehicle_slot_size)
                elsif slot_availability("large")
                    park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "large")
                    @small_in_large_slot.store(license_plate_number, vehicle_slot_size)
                else
                    puts "No space for small sized vehicle"
                end
            elsif vehicle_slot_size == "medium"
                if slot_availability("medium")
                    park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "medium")
                elsif slot_availability("small") && !@small_in_medium_slot.empty?
                    sort_slot(@small_in_medium_slot)
                    admit_the_vehicle(license_plate_number, vehicle_slot_size)
                elsif slot_availability("small") && !@small_in_large_slot.empty?
                    sort_slot(@small_in_large_slot)
                    admit_the_vehicle(license_plate_number, vehicle_slot_size)
                elsif slot_availability("large")
                    park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "medium")
                    @medium_in_large_slot.store(license_plate_number, vehicle_slot_size)
                else 
                    puts "No space for medium sized vehicle"
                end
            else
                if vehicle_slot_size == "large"
                    if slot_availability("large")
                        park_vehicle_to_slot(license_plate_number, vehicle_slot_size, "large")
                    elsif !@small_in_large_slot.empty? && slot_availability("small")
                        sort_slot(@small_in_large_slot)
                        admit_the_vehicle(license_plate_number, vehicle_slot_size)
                    elsif !@medium_in_large_slot.empty? && slot_availability("medium")
                        sort_slot(@medium_in_large_slot)
                        admit_the_vehicle(license_plate_number, vehicle_slot_size)
                    elsif !@medium_in_large_slot.empty? && !small_in_medium_slot.empty? && slot_availability("small")
                        sort_slot(small_in_medium_slot)
                        sort_slot(medium_in_large_slot)
                        admit_the_vehicle(license_plate_number, vehicle_slot_size)
                    else
                        puts "No space for large sized vehicle"
                    end
                else
                    puts "Error in input size"
                end
            end
        else
            puts "Vehicle already exist"     
        end
    end
    
    def exit_vehicle(license_plate_number)
        if @all_vehicles.has_key?(license_plate_number)
            if !@medium_in_large_slot.empty?() && !@small_in_medium_slot.empty?() && !@small_in_large_slot.empty?()
                if @medium_in_large_slot.has_key?(license_plate_number)
                    remove_vehicle_from_slot(license_plate_number, "large")
                    @medium_in_large_slot.delete(license_plate_number)
                elsif @small_in_large_slot.has_key?(license_plate_number)
                    remove_vehicle_from_slot(license_plate_number, "large")
                    @small_in_large_slot.delete(license_plate_number)
                elsif @small_in_medium_slot.has_key?(license_plate_number)
                    remove_vehicle_from_slot(license_plate_number, "medium")
                    @small_in_medium_slot.delete(license_plate_number)
                end
            else 
                remove_vehicle_from_slot(license_plate_number, @all_vehicles[license_plate_number][1])
            end
        else
            puts "Vehicle not found at parking lot"
        end
    end

    private

        def park_vehicle_to_slot(license_plate_number, vehicle_slot_size, admited_parking_slot)
            @all_vehicles.store(license_plate_number,[vehicle_slot_size, admited_parking_slot]) # here we are storing license_plate_number, inputed slot, current slot/admitted slot respectively
            @available_slots[admited_parking_slot] -= 1
        end

        def remove_vehicle_from_slot(license_plate_number, slot)
            @all_vehicles.delete(license_plate_number)
            @available_slots[slot] += 1
        end

        def sort_slot(sorting_vehicle)
            moving_vehicle = sorting_vehicle.first
            exit_vehicle(moving_vehicle[0])
            admit_the_vehicle(*moving_vehicle)
        end

        def slot_availability(vehicle_size)
            @available_slots[vehicle_size] > 0
        end
            
end

# Testing ParkingSystem

example = ParkingSystem.new(1,1,2) # Initilizing parking lot slot availability ParkingSystem.new(small, medium, large)
example.admit_the_vehicle("A1", "small")
example.admit_the_vehicle("A2", "small")
example.admit_the_vehicle("A3", "small")
example.admit_the_vehicle("A5", "small")
example.admit_the_vehicle("A6", "small")

puts "Available slots :", example.available_slots
puts "All vehicles:", example.all_vehicles # Output = license_plate_number =>  [inputed slot, current slot/admitted]