enum ViewStatus {
  // For waiting data
  loading,

  // To tell us the screen is ready
  idle,

  // In action of submitting data
  submitting,
  
  // For intended function already run
  success,

  // For intended function failed to run
  failure,
}