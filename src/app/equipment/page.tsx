'use client'

import { useEffect, useState } from 'react'
import { useStore } from '@/store/useStore'
import { Camera, Search, Filter, Plus } from 'lucide-react'

export default function EquipmentPage() {
  const { equipment, loading, error, fetchEquipment } = useStore()
  const [searchTerm, setSearchTerm] = useState('')
  const [filterCondition, setFilterCondition] = useState<string>('')

  useEffect(() => {
    fetchEquipment()
  }, [fetchEquipment])

  const filteredEquipment = equipment.filter(item => {
    const matchesSearch = item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.brand?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.model?.toLowerCase().includes(searchTerm.toLowerCase()) ||
      item.serial_number?.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesCondition = filterCondition ? item.condition === filterCondition : true

    return matchesSearch && matchesCondition
  })

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg">Loading equipment...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-lg text-red-600">{error}</div>
      </div>
    )
  }

  return (
    <div className="container mx-auto p-8">
      <div className="flex justify-between items-center mb-8">
        <div className="flex items-center gap-2">
          <Camera className="w-8 h-8 text-blue-500" />
          <h1 className="text-3xl font-bold">Equipment</h1>
          <span className="bg-blue-100 text-blue-800 text-sm px-3 py-1 rounded-full">
            {filteredEquipment.length} items
          </span>
        </div>
        <button className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 transition-colors flex items-center gap-2">
          <Plus className="w-4 h-4" />
          Add Equipment
        </button>
      </div>

      <div className="mb-6 flex gap-4 flex-col sm:flex-row">
        <div className="relative flex-1">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
          <input
            type="text"
            placeholder="Search equipment..."
            className="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        <select
          className="border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
          value={filterCondition}
          onChange={(e) => setFilterCondition(e.target.value)}
        >
          <option value="">All Conditions</option>
          <option value="Excellent">Excellent</option>
          <option value="Good">Good</option>
          <option value="Fair">Fair</option>
          <option value="Poor">Poor</option>
        </select>
      </div>

      {filteredEquipment.length === 0 ? (
        <div className="text-center py-12 bg-gray-50 rounded-lg">
          <p className="text-gray-600">No equipment found</p>
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredEquipment.map((item) => (
            <div key={item.id} className="bg-white rounded-lg shadow-sm hover:shadow-md transition-shadow p-6">
              <div className="flex justify-between items-start mb-4">
                <h2 className="text-xl font-semibold">{item.name}</h2>
                <span className={`px-2 py-1 rounded text-sm ${
                  item.condition === 'Excellent' ? 'bg-green-100 text-green-800' :
                  item.condition === 'Good' ? 'bg-blue-100 text-blue-800' :
                  item.condition === 'Fair' ? 'bg-yellow-100 text-yellow-800' :
                  'bg-red-100 text-red-800'
                }`}>
                  {item.condition}
                </span>
              </div>
              
              <div className="space-y-2 text-gray-600">
                {item.brand && (
                  <div className="flex justify-between">
                    <span className="font-medium">Brand:</span>
                    <span>{item.brand}</span>
                  </div>
                )}
                {item.model && (
                  <div className="flex justify-between">
                    <span className="font-medium">Model:</span>
                    <span>{item.model}</span>
                  </div>
                )}
                {item.serial_number && (
                  <div className="flex justify-between">
                    <span className="font-medium">Serial:</span>
                    <span className="font-mono text-sm">{item.serial_number}</span>
                  </div>
                )}
                {item.purchase_date && (
                  <div className="flex justify-between">
                    <span className="font-medium">Purchased:</span>
                    <span>{new Date(item.purchase_date).toLocaleDateString()}</span>
                  </div>
                )}
                {item.purchase_price && (
                  <div className="flex justify-between">
                    <span className="font-medium">Price:</span>
                    <span>${item.purchase_price.toLocaleString()}</span>
                  </div>
                )}
              </div>

              {item.notes && (
                <div className="mt-4 pt-4 border-t border-gray-100">
                  <p className="text-sm text-gray-500">{item.notes}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
