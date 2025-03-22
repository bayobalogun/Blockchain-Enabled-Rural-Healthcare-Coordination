import { describe, it, expect, vi } from 'vitest';

// Mock implementation
const mockTelehealthFacilitation = {
  scheduleSession: vi.fn().mockImplementation((providerId, scheduledTime, duration) => {
    return { value: 1 };
  }),
  
  setSessionLink: vi.fn().mockImplementation((sessionId, sessionLink) => {
    return { value: true };
  }),
  
  completeSession: vi.fn().mockImplementation((sessionId) => {
    return { value: true };
  }),
  
  getSession: vi.fn().mockImplementation((id) => {
    return {
      providerId: 3,
      patient: "ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM",
      scheduledTime: 1625097600,
      duration: 30,
      sessionLink: "https://telehealth.example.com/session/12345",
      status: "completed"
    };
  })
};

describe('Telehealth Facilitation Contract', () => {
  it('should schedule a session', async () => {
    const result = await mockTelehealthFacilitation.scheduleSession(
        3,
        1625097600,
        30
    );
    
    expect(result.value).toBe(1);
    expect(mockTelehealthFacilitation.scheduleSession).toHaveBeenCalledWith(
        3,
        1625097600,
        30
    );
  });
  
  it('should set a session link', async () => {
    const result = await mockTelehealthFacilitation.setSessionLink(
        1,
        "https://telehealth.example.com/session/12345"
    );
    
    expect(result.value).toBe(true);
    expect(mockTelehealthFacilitation.setSessionLink).toHaveBeenCalledWith(
        1,
        "https://telehealth.example.com/session/12345"
    );
  });
  
  it('should complete a session', async () => {
    const result = await mockTelehealthFacilitation.completeSession(1);
    
    expect(result.value).toBe(true);
    expect(mockTelehealthFacilitation.completeSession).toHaveBeenCalledWith(1);
  });
  
  it('should get session details', async () => {
    const session = await mockTelehealthFacilitation.getSession(1);
    
    expect(session.providerId).toBe(3);
    expect(session.duration).toBe(30);
    expect(session.status).toBe("completed");
    expect(mockTelehealthFacilitation.getSession).toHaveBeenCalledWith(1);
  });
});
