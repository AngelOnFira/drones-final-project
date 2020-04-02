extends Node

const NUM_OF_DRONES = 500
const NUM_OF_CLUSTERS = int((sqrt(8 * NUM_OF_DRONES + 1) - 1) / 2)

# In bytes/second
const RECEPTION_RATE = 10000

# In bytes/second
const TRANSMISSION_RATE = 10000
