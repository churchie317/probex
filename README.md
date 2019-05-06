# Probex

Probex is a fault-tolerant, lightweight HTTP service for managing application `liveness` and `readiness` checks.

Many container orchestration platforms such as Kubernetes can be extended by configuring probes that test their container's liveness and readiness states. These probes are especially useful when your container needs to execute long-running startup actions like processing large quantities of data.

The routes used to probe these states should not be exposed on public network interfaces. For example, imagine running a Phoenix web application `MyPhxApp` that takes ~30 seconds to load data into an in-memory cache. Adding probe routes to `MyPhxApp.Router` would expose diagnositc data to all network consumers of the application. Probex solves this problem by starting an HTTP service that is only available to the orchestration platform and therefore not exposed to application consumers.

For more information about Kubernetes readiness and liveness checks, refer to the following documentation:

- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Configuring Liveness and Readiness Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-probes/#define-a-liveness-http-request)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `probex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:probex, "~> 0.1.0"}
  ]
end
```

Then, run `mix deps.get` to fetch the dependency.

## Usage

Probex is simple: it starts an HTTP service and provides a narrow API for updating the state of that service.

A service is started via `start_link/1`:

```elixir
{:ok, pid} = Probex.start_link(name: :diagnostic_probe)
```

Similarly, a service instance can be started under a supervision tree by passing the following to a supervisor's children:

```elixir
{Probex, name: :diagnostic_probe}
```

This starts a service on port `9000` and can be probed by issuing requests to the `/live` and `/ready` endpoints. Initially, these endpoints will return `50x` status codes reflecting program unavailable states. When the service is alive and healthy, calling `Probex.signal_ready(:diagnostic_probe)` updates the service's internal state and causes requests to the `/ready` endpoint to respond with `200`s. Likewise, invoking `Probex.signal_alive(:diagnostic_probe)` updates the service's internal state and causes requests to `/live` to respond with `200`s. `Probex.signal_pending(:diagnostic_probe)` and `Probex.signal_unavailable(:diagnostic_probe)` cause the service to return `50x`s.
