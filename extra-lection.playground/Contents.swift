/// `Truck` can `pickUp` loads from the storage, and `dropOff` loads into the storage.
class Truck {

    // MARK: internal interface

    /// The maximum capacity of the `Truck`.
    let weightCapacity: Int

    /// Unique number of the `Truck`.
    let truckNumber: String

    // TODO: var currentLoadsList = Set<Load>()

    /// Initializes a new `Truck` object with the specified maximum weight capacity and truck number.
    ///
    /// - Parameters:
    /// - maxWeightCapacity: The maximum weight capacity of the truck.
    /// - truckNumber: The unique identifier number for the truck.
    ///
    /// - Throws:
    /// An error of type `Errors.valueAlreadyUsed` if the `truckNumber` parameter is already used for another `Truck` object.
    ///
    /// - Note:
    /// Each truck must have a unique `truckNumber` identifier. If the provided `truckNumber` is already used by another `Truck` object, an error of type  `Errors.valueAlreadyUsed` will be thrown.
    ///
    /// - Important:
    /// The `usedNumbers` dictionary keeps track of all `truckNumber` values that have already been used. This dictionary is shared across all instances of the `Truck` class.
    init(maxWeightCapacity: Int, truckNumber: String) throws {
        if Truck.usedNumbers[truckNumber] == true {
            throw Errors.valueAlreadyUsed
        }

        Truck.usedNumbers[truckNumber] = true
        weightCapacity = maxWeightCapacity
        self.truckNumber = truckNumber
    }

    /// Pick up load onto the truck.
    /// - Parameter load: the load that will be loaded onto the truck.
    ///
    /// If the maximum load will be exceeded, the function will stop working.
    func pickUp(load: Load) {
        if currentWeightCapacity + load.loadWeight > weightCapacity {
            print("The maximum capacity has been exceeded. The load cannot be loaded.")
            return
        } else {
            currentWeightCapacity += load.loadWeight
           // TODO: currentLoadsList.append(load)
        }
    }

    /// Drop off load from the truck.
    /// - Parameter load: the load that will be dropped off from the truck.
    func dropOff(load: Load) {
        currentWeightCapacity -= load.loadWeight
        // TODO: currentLoadsList.remove(load)
    }

        // MARK: Private interface
    /// Shows current capacity of the truck
    private(set) var currentWeightCapacity: Int = 0
    /// Contains truck numbers that have already been used.
    private(set) static var usedNumbers = [String : Bool]()
}

///  The class describes the place where loads can be unloaded, and from where they can be picked up.
///  Method `dropOffToStorage` describe  the process of unloading load into the warehouse. When load has unloaded,
///  current capcity of storage encreasing. Method `putInTruck` describes the process of loading cargo onto a truck.
///  At this moment, the current load of the warehouse decreases, and the truck increases.
class Storage {

    // MARK: Internal interface

    /// determines the maximum capacity of the storage
    let storageCapacity: Int
    let storageName: String

    init(maxStorageCapacity: Int) {
        storageCapacity = maxStorageCapacity
    }
    /// This method describes the process of unloading a truck of a certain cargo in storage
    /// When unloading a truck, its current load is reduced by the weight of the load
    /// - Parameter dropLoad: instance of class Load
    /// - Parameter truck: instance of class Truck
    func dropOffToStorage(dropLoad: Load, truck: Truck) {
        guard currentStorageWeight + dropLoad.loadWeight <= storageCapacity else { return }

        truck.dropOff(weight: Load(loadWeight: dropLoad.loadWeight))
        currentStorageWeight += dropLoad.loadWeight
    }
    /// The function reduces the current capacity of the storage and increases the current capacity of the truck
    /// - Parameter putInWeight:instance of the class Load
    /// - Parameter truck: instance of class  Truck.
    func putInTruck(putInWeight: Load, truck: Truck) {
        guard truck.currentWeightCapacity + putInWeight.loadWeight <= truck.weightCapacity else { return }

        truck.pickUp(weight: Load(loadWeight: putInWeight.loadName.loadWeight))
        currentStorageWeight -= putInWeight.loadWeight

        }

    // MARK: Private interface

    private(set) var currentStorageWeight: Int = 0
}

/// Class describes a loads.
/// Have one propety `loadWeight` that describes weight of load instance.
class Load {
    let loadName: String
    let loadWeight: Int

    init(loadWeight: Int, loadName: String) {
        self.loadWeight = loadWeight
        self.loadName = loadName
       }

}

enum Errors: Error {
    case valueAlreadyUsed
}

let renault0521 = try Truck(maxWeightCapacity: 10000, truckNumber: "0521")
