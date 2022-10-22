defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    bucket_name = "shopping"
    key = "milk"
    value = 1

    assert KV.Registry.lookup(registry, bucket_name) == :error

    KV.Registry.create(registry, bucket_name)
    assert {:ok, bucket} = KV.Registry.lookup(registry, bucket_name)

    KV.Bucket.put(bucket, key, value)
    assert KV.Bucket.get(bucket, key) == value
  end

  test "removes buckets on exit", %{registry: registry} do
    bucket_name = "shopping"
    KV.Registry.create(registry, bucket_name)
    {:ok, bucket} = KV.Registry.lookup(registry, bucket_name)

    Agent.stop(bucket)
    assert KV.Registry.lookup(registry, bucket_name) == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    bucket_name = "shopping"
    KV.Registry.create(registry, bucket_name)
    {:ok, bucket} = KV.Registry.lookup(registry, bucket_name)

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    assert KV.Registry.lookup(registry, bucket_name) == :error
  end
end
