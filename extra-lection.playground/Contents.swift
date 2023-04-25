import XCTest

/// Truck that can transporting loads.
final class Truck {

    // MARK: Internal interface.

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
    init(maxWeightCapacity: Int) {
        weightCapacity = maxWeightCapacity
        self.truckId = UUID()
    }

    /// Picks up the specified `Load` onto the `Truck` if the maximum weight capacity is not exceeded, and the `Load` has not already been picked up recently.
    ///
    /// - Description: The current weight capacity of the `Truck` will increase by the weight
    /// of the `Load`, and the `Load` will also be added to the list of current loads of the `Truck` and the list of all picked up loads of all trucks.
    ///
    /// - Parameter load: The `Load` to be loaded onto the current `Truck`.
    /// - Returns: A Boolean value indicating whether the operation successful. If the maximum capacity will be exceeded, or `Load` have already picked up
    /// recently, the `Load` will not be picked up and the method returns `false`. If the `Load` is picked up successfully, the method returns `true`.
    func pickUp(currentLoad: Load, storage: Storage) -> Bool {
        guard currentWeightCapacity + currentLoad.loadWeight <= weightCapacity else { return false }
        guard !currentLoadsInTruck.contains(currentLoad) else { return false }
        guard storage.containsLoad(load: currentLoad) != true else { return false }

        currentWeightCapacity += currentLoad.loadWeight
        currentLoadsInTruck.insert(currentLoad)
        storage.dropOffFromStorage(load: currentLoad)
        return true
    }

    /// Drop off the specified `Load` from the `Truck`.
    ///
    /// - Description: A `Load` can only be dropped off from the current `Truck` if it is currently in the `Truck`.
    ///  If the `Load` is successfull dropped off, the load's weight is subtracted from the current weight
    ///  capacity of the `Truck`, the `Load` is removed from the list of current loads in the `Truck`.
    ///
    /// - Parameter load: The  `Load` that will be dropped off from the truck.
    ///
    /// - Returns: A Boolean value indicating whether the operation successfull. Returns `true` if the
    ///  `Load` is in the truck and successfull dropped off, and `false` otherwise.
    func dropOff(currentLoad: Load, storage: Storage) -> Bool {
        guard currentLoadsInTruck.contains(currentLoad) else { return false }

        currentWeightCapacity -= currentLoad.loadWeight
        currentLoadsInTruck.remove(currentLoad)
        storage.pickUpToStorage(load: currentLoad)
        return true
    }

    // MARK: Private interface.

    /// Сurrent capacity of the truck.
    private(set) var currentWeightCapacity: Int = 0 // weightCapacity = 0 не хорошо
    /// Contains current list of loads, which are in the truck.
    private(set) var currentLoadsInTruck: Set<Load> = []
}

/// Storage is a space for storing loads.
final class Storage {

    // MARK: Internal interface.

    /// Determines the maximum capacity of the storage.
    /// Unit of measure is kilograms.
    let storageCapacity: Int

    /// Represents the name of the storage.
    let storageName: String

    /// Initializer for the `Storage` class, which sets the initial maximum storage capacity and storage name.
    /// - Parameters:
    /// - maxStorageCapacity:  the maximum storage capacity of the Storage. Unit of measure is kilograms.
    /// - storageName: A string value representing the name of the `Storage`.
    init(maxStorageCapacity: Int, storageName: String) {
         storageCapacity = maxStorageCapacity
         self.storageName = storageName
    }

    /// Picks up a load to the storage.
    ///
    /// - Parameter load: The `Load` that needs to pick up to the storage.
    ///
    /// - Description: The method picks up `Load` to the storage. The method checks if the load's weight
    /// is less than or equal to the remaining capacity of the storage, and if the load is not already present in the storage.
    /// If both conditions are met, the method picks up the load to the storage and updates the current storage weight.
    ///
    /// - Returns: `true` if the load was successfully pick upped, or `false` if the storage is already
    /// at maximum capacity or the load already exists in the storage.
    func pickUpToStorage(load: Load) -> Bool {
        guard currentStorageWeight + load.loadWeight <= storageCapacity else { return false }
        guard !currentLoadsInStorage.contains(load) else { return false }

        currentStorageWeight += load.loadWeight
        currentLoadsInStorage.insert(load)
        return true
    }

    /// Drops off a load from the storage.
    ///
    /// - Parameter load: The `load` that needs to be dropped off from the storage.
    ///
    /// - Description: This method removes a given load from the current loads in storage, reducing
    /// the current storage weight. The method checks, that `load` being droped off contains in the storage.
    ///
    /// - Returns: If the load is not in the storage, the function returns `false`.
    /// Otherwise, it returns `true` to indicate that the load was successfully dropped off from the storage.
    func dropOffFromStorage(load: Load) -> Bool {
        guard currentLoadsInStorage.contains(load) else { return false }

        currentStorageWeight -= load.loadWeight
        currentLoadsInStorage.remove(load)
        return true
    }

    /// This method checks whether the given load is currently stored in the storage.
    ///
    /// - Parameter load: The load, that contains in the storage.
    ///
    /// - Returns:Method returns `true` if the load is not in storage, and `false` otherwise.
    func containsLoad(load: Load) -> Bool {
        guard !currentLoadsInStorage.contains(load) else { return false }

        return true
    }

    // MARK: Private interface.

    /// Current storage weight depending on the weight of containing loads.
    private(set) var currentStorageWeight: Int = 0

    /// Loads that have been picked up to storage recently.
    private(set) var currentLoadsInStorage: Set<Load> = []
 }

/// Load that can be transported by truck.
final class Load: Hashable {

    /// The unique identifier.
    let id: UUID

    /// The weight of the `Load`.
    /// Unit of measure kilograms.
    let loadWeight: Int

    /// Shipping name of the `Load`.
    let loadName: String

    /// Initializes a new `Load` object with the specified identifier and weight.
    /// - Parameters:
    /// - id: The unique identifier for the `Load`.
    /// - weight: The weight of the load. Must be greater than 0.
    init(name: String, weight: Int) { // valiable inizializators
        guard weight > 0 else { fatalError("Load weight must be greater than 0") }

        loadName = name
        loadWeight = weight
        self.id = UUID()
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

