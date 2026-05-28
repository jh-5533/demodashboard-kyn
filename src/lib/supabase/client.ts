// Demo mode stub — no real Supabase connection needed
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function createClient(): any {
  return {
    auth: {
      getUser:            async () => ({ data: { user: { email: 'demo@boomhaus.sg', id: 'demo-user' } }, error: null }),
      getSession:         async () => ({ data: { session: null }, error: null }),
      signOut:            async () => ({ error: null }),
      signInWithOAuth:    async () => ({ data: null, error: null }),
      exchangeCodeForSession: async () => ({ data: null, error: null }),
      onAuthStateChange:  () => ({ data: { subscription: { unsubscribe: () => {} } } }),
    },
  }
}
