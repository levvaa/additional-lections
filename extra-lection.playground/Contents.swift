import XCTest

/// Represents truck that can transporting loads.
class Truck {

    // MARK: internal interface.

    /// The maximum capacity of the truck.
    /// Unit of measure is kilograms.
    let weightCapacity: Int
    /// Unique id of the truck.
    let truckId: UUID

    /// Initializes a new `Truck` object with the specified maximum weight capacity and truck id.
    ///
    /// - Parameters:
    /// - maxWeightCapacity: The maximum weight capacity of the truck.
    /// - id: The unique identifier for the truck.
    init(maxWeightCapacity: Int, truckId: UUID) {
        weightCapacity = maxWeightCapacity
        self.truckId = truckId
    }

    /// Pick up the specified `Load` onto the `Truck` if the maximum weight capacity is not exceeded, and the `Load` has not already been picked up recently.
    ///
    /// - Description: If the maximum capacity will be exceeded, or `Load` have already picked up recently, the `Load` will not be picked up and the method returns `false`. If the `Load` is picked up successfully, the method returns `true`. The current weight capacity of the `Truck` will increase by the weight of the `Load`, and the `Load` will also be added to the list of current loads of the `Truck` and the list of all picked up loads of all trucks.
    ///
    /// - Parameter load: The `Load` to be loaded onto the `Truck`.
    /// - Returns: A Boolean value indicating whether the operation successful. Returns `true` if the `Load` successfull picked up and `false` otherwise.
    func pickUp(load: Load) -> Bool {
        guard currentWeightCapacity + load.loadWeight <= weightCapacity else { return false }

        if let loadedTrucks = Truck.currentLoadsInTrucks[load], !loadedTrucks.isEmpty {
            return false
        }

        if !currentLoadsList.contains(load) {
            currentWeightCapacity += load.loadWeight
            currentLoadsList.insert(load)
            Truck.currentLoadsInTrucks[load] = [self]
            return true
        }
        return false
    }

    /// Drop off the specified `Load` from the `Truck`.
    ///
    /// - Description: A `Load` can only be dropped off from the `Truck` if it is currently in the `Truck`. If the `Load` is successfull dropped off, the load's weight is subtracted from the current weight capacity of the `Truck`, the `Load` is removed from the list of current loads in the `Truck`, and the `Load` removes from the list of loads in all trucks.
    ///
    /// - Parameter load: The `Load` that will be dropped off from the truck.
    ///
    /// - Returns: A Boolean value indicating whether the operation successfull. Returns `true` if the `Load` is in the truck and successfull dropped off, and `false` otherwise.
    func dropOff(load: Load) -> Bool {
        if currentLoadsList.contains(load) {
            currentWeightCapacity -= load.loadWeight
            currentLoadsList.remove(load)
            Truck.currentLoadsInTrucks.removeValue(forKey: load)
            return true
        }
        return false
    }

    // MARK: Private interface.

    /// Shows current capacity of the truck.
    private(set) var currentWeightCapacity: Int = 0
    /// Contains current list of loads, which are in the truck.
    private(set) var currentLoadsList: Set<Load> = []
    /// Contains a list of which loads are in trucks.
    private(set) static var currentLoadsInTrucks: [Load: [Truck]] = [:]
}

 class Storage {

    // MARK: Internal interface.

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

/// Represents a load that can be transported by a truck.
class Load: Hashable {
    /// The unique identifier for the `Load`.
    let id: UUID
    /// The weight of the `Load`.
    /// Unit of measure kilograms.
    let loadWeight: Int
    /// Shipping name of the `Load`.
    let loadName: String

    /// Initializes a new `Load` object with the specified identifier and weight.
    ///
    /// - Parameters:
    /// - id: The unique identifier for the `Load`.
    /// - weight: The weight of the load. Must be greater than 0.
    init(id: UUID, name: String, weight: Int) {
        guard weight > 0 else { fatalError("Load weight must be greater than 0") }

        self.id = id
        loadWeight = weight
        loadName = name
    }
    /// Returns a Boolean value indicating whether two `Load` objects are equal.
    static func == (lhs: Load, rhs: Load) -> Bool {
        return lhs.id == rhs.id
    }
    /// Hashes the essential components of the `Load` by feeding them into the given hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components of the `Load`.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


