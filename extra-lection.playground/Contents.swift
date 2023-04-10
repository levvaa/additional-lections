/// Сlass describes a truck that can pick up and drop off loads
/// Method `pickUp`, that increase current capacity of truck, and `dropOff` that reduce carrent capacity.
/// Capacity cannot be negative value.
class Truck {
    /// determines the maximum volume of the truck
    let weightCapacity: UInt

    // MARK: internal interface

    init(maxWeightCapacity: UInt) {
        weightCapacity = maxWeightCapacity
    }
    /// This function increases the current weight of truck.
    /// - Parameter weight: instance of class Load with current weight.
    /// If the maximum capacity of the truck is exceeded, returns false.
    func pickUp(weight: Load) {

        guard currentWeight + weight.loadWeight <= weightCapacity else { return }

        currentWeight += weight.loadWeight
    }

    /// Function reduces the current weight. If the result is less than zero, returns false.
    /// - Parameter weight: the value by which the current capacity will be reduced
    /// If after unloading the scales of the total capacity of the truck, returns false
    func dropOff(weight: Load) {

        currentWeight -= weight.loadWeight
    }
        // MARK: Private interface
    private(set) var currentWeight: UInt = 0
}

///  The class describes the place where loads can be unloaded, and from where they can be picked up.
///  Method `dropOffToStorage` describe  the process of unloading load into the warehouse. When load has unloaded,
///  current capcity of storage encreasing. Method `putInTruck` describes the process of loading cargo onto a truck.
///  At this moment, the current load of the warehouse decreases, and the truck increases.
///  The store cannot store negative values.
class Storage {

    // MARK: Internal interface

    /// determines the maximum capacity of the storage
    let storageCapacity: UInt

    init(maxStorageCapacity: UInt) {
        storageCapacity = maxStorageCapacity
    }
    /// This method describes the process of unloading a truck of a certain cargo in storage
    /// When unloading a truck, its current load is reduced by the weight of the load
    /// - Parameter dropLoad: instance of class Load
    /// - Parameter truck: instance of class Truck
    /// If the maximum capacity of the storage is exceeded, returns false.
    func dropOffToStorage(dropLoad: Load, truck: Truck) {
        guard currentStorageWeight + dropLoad.loadWeight <= storageCapacity else { return }

        truck.dropOff(weight: Load(loadWeight: dropLoad.loadWeight))
        currentStorageWeight += dropLoad.loadWeight
    }
        /// The function reduces the current capacity of the storage and increases the current capacity of the truck
        /// - Parameter putInWeight:instance of the class Load
        /// - Parameter truck: instance of class  Truck.
        /// If the maximum capacity of the truck is exceeded, returns false.
    func putInTruck(putInWeight: Load, truck: Truck) {
        guard truck.currentWeight + putInWeight.loadWeight <= truck.weightCapacity else { return }

        truck.pickUp(weight: Load(loadWeight: putInWeight.loadWeight))
        currentStorageWeight -= putInWeight.loadWeight

        }

    // MARK: Private interface

    private(set) var currentStorageWeight: UInt = 0
}

/// Class describes a loads.
/// Have one propety `loadWeight` that describes weight of load instance.
class Load {

    let loadWeight: UInt

    init(loadWeight: UInt) {
           self.loadWeight = loadWeight
       }

}

