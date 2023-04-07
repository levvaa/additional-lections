class Truck {
    let weightCapacity: Int

    // MARK: internal interface

    init(maxWeightCapacity: Int) {
        weightCapacity = maxWeightCapacity
    }
    /// This function increases the current weight. Сurrent weight cannot be more than 50000
    /// - Parameters:the weight by which the current load will be increased
    func pickUp(weight: Int) {
        guard currentWeight + weight <= weightCapacity else { return }

        currentWeight += weight
    }

    /// Function reduces the current weight. If the result is less than zero, returns false.
    /// - Parameters: weight, that will be reduced
    func dropOff(weight: Int) {
        guard currentWeight - weight >= 0 else { return }

        currentWeight = currentWeight - weight
    }
        // MARK: Private interface
    private(set) var currentWeight = 0
}

class Storage {
    let storageCapacity: Int

    init(maxStorageCapacity: Int) {
        storageCapacity = maxStorageCapacity
    ///
    func dropOffToStorage(_ dropWeight: Int, _ truck: Truck) {
        guard currentStorageWeight + dropWeight <= storageCapacity else { return }

        truck.dropOff(weight: dropWeight)
        currentStorageWeight += dropWeight
    }

    func putInTruck(putInWeight: Int, truck: Truck) {
        guard currentStorageWeight - putInWeight >= 0 else { return }

        truck.pickUp(weight: putInWeight)
        currentStorageWeight -= putInWeight

        }
    }

    private(set) var currentStorageWeight = 0
}

    // TODO: class Load (описывает груз)

