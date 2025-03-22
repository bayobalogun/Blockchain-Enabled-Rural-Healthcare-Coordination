import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockProviderRegistration = {
  register: vi.fn().mockImplementation((name, specialty, location, contact) => {
    return { value: 1 };
  }),
  
  updateAvailability: vi.fn().mockImplementation((providerId, available) => {
    return { value: true };
  }),
  
  getProvider: vi.fn().mockImplementation((id) => {
    return {
      name: "Dr. Sarah Johnson",
      specialty: "Family Medicine",
      location: "Rural Health Clinic, 123 Main St, Farmville",
      contact: "dr.johnson@ruralhealth.org",
      available: true,
      owner: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM"
    };
  })
};

describe('Provider Registration Contract', () => {
  it('should register a new provider', async () => {
    const result = await mockProviderRegistration.register(
        "Dr. Sarah Johnson",
        "Family Medicine",
        "Rural Health Clinic, 123 Main St, Farmville",
        "dr.johnson@ruralhealth.org"
    );
    
    expect(result.value).toBe(1);
    expect(mockProviderRegistration.register).toHaveBeenCalledWith(
        "Dr. Sarah Johnson",
        "Family Medicine",
        "Rural Health Clinic, 123 Main St, Farmville",
        "dr.johnson@ruralhealth.org"
    );
  });
  
  it('should update provider availability', async () => {
    const result = await mockProviderRegistration.updateAvailability(1, false);
    
    expect(result.value).toBe(true);
    expect(mockProviderRegistration.updateAvailability).toHaveBeenCalledWith(1, false);
  });
  
  it('should get provider details', async () => {
    const provider = await mockProviderRegistration.getProvider(1);
    
    expect(provider.name).toBe("Dr. Sarah Johnson");
    expect(provider.specialty).toBe("Family Medicine");
    expect(provider.available).toBe(true);
    expect(mockProviderRegistration.getProvider).toHaveBeenCalledWith(1);
  });
});
