/// Truck can pickUp loads from the storage, and dropOff loads into the storage.
class Truck {

    // MARK: internal interface

    /// determines the maximum capacity of the truck.
    let weightCapacity: Int
    /// individual number of the truck.
    let truckNumber: String

    init(maxWeightCapacity: Int, truckNumber: String) throws {
        if Truck.usedNumbers[truckNumber] == true {
            throw Errors.valueAlreadyUsed
        }

        Truck.usedNumbers[truckNumber] = true
        weightCapacity = maxWeightCapacity
        self.truckNumber = truckNumber
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
    private(set) var currentWeight: Int = 0
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
        guard truck.currentWeight + putInWeight.loadWeight <= truck.weightCapacity else { return }

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
