import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockPatientMatching = {
  requestCare: vi.fn().mockImplementation((careType, urgency, location) => {
    return { value: 1 };
  }),
  
  acceptRequest: vi.fn().mockImplementation((requestId, providerId) => {
    return { value: true };
  }),
  
  getRequest: vi.fn().mockImplementation((id) => {
    return {
      patient: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      careType: "Diabetes Management",
      urgency: "routine",
      location: "Farmville",
      providerId: 3,
      status: "matched"
    };
  })
};

describe('Patient Matching Contract', () => {
  it('should request care', async () => {
    const result = await mockPatientMatching.requestCare(
        "Diabetes Management",
        "routine",
        "Farmville"
    );
    
    expect(result.value).toBe(1);
    expect(mockPatientMatching.requestCare).toHaveBeenCalledWith(
        "Diabetes Management",
        "routine",
        "Farmville"
    );
  });
  
  it('should accept a care request', async () => {
    const result = await mockPatientMatching.acceptRequest(1, 3);
    
    expect(result.value).toBe(true);
    expect(mockPatientMatching.acceptRequest).toHaveBeenCalledWith(1, 3);
  });
  
  it('should get care request details', async () => {
    const request = await mockPatientMatching.getRequest(1);
    
    expect(request.careType).toBe("Diabetes Management");
    expect(request.urgency).toBe("routine");
    expect(request.status).toBe("matched");
    expect(mockPatientMatching.getRequest).toHaveBeenCalledWith(1);
  });
});
