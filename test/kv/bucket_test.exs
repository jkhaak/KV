defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(KV.Bucket, [])
    %{bucket: bucket}
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end

  test "stores values by key", %{bucket: bucket} do
    key = "milk"
    assert KV.Bucket.get(bucket, key) == nil

    KV.Bucket.put(bucket, key, 3)
    assert KV.Bucket.get(bucket, key) == 3
  end

  test "delete a value by key", %{bucket: bucket} do
    key = "milk"
    value = 3
    assert KV.Bucket.get(bucket, key) == nil
    KV.Bucket.put(bucket, key, value)
    assert KV.Bucket.get(bucket, key) == 3

    value_popped = KV.Bucket.delete(bucket, key)
    assert KV.Bucket.get(bucket, key) == nil
    assert value == value_popped
  end
end
