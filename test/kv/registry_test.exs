defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    bucket_name = "shopping"
    key = "milk"
    assert KV.Registry.lookup(registry, bucket_name) == :error

    KV.Registry.create(registry, bucket_name)
    assert {:ok, bucket} = KV.Registry.lookup(registry, bucket_name)

    KV.Bucket.put(bucket, key, 1)
    assert KV.Bucket.get(bucket, key) == 1
  end
end
