/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 4.0.1
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
 * ----------------------------------------------------------------------------- */

package com.herumi.bls;

public class SignatureVec extends java.util.AbstractList<Signature> implements java.util.RandomAccess {
  private transient long swigCPtr;
  protected transient boolean swigCMemOwn;

  protected SignatureVec(long cPtr, boolean cMemoryOwn) {
    swigCMemOwn = cMemoryOwn;
    swigCPtr = cPtr;
  }

  protected static long getCPtr(SignatureVec obj) {
    return (obj == null) ? 0 : obj.swigCPtr;
  }

  @SuppressWarnings("deprecation")
  protected void finalize() {
    delete();
  }

  public synchronized void delete() {
    if (swigCPtr != 0) {
      if (swigCMemOwn) {
        swigCMemOwn = false;
        BlsJNI.delete_SignatureVec(swigCPtr);
      }
      swigCPtr = 0;
    }
  }

  public SignatureVec(Signature[] initialElements) {
    this();
    reserve(initialElements.length);

    for (Signature element : initialElements) {
      add(element);
    }
  }

  public SignatureVec(Iterable<Signature> initialElements) {
    this();
    for (Signature element : initialElements) {
      add(element);
    }
  }

  public Signature get(int index) {
    return doGet(index);
  }

  public Signature set(int index, Signature e) {
    return doSet(index, e);
  }

  public boolean add(Signature e) {
    modCount++;
    doAdd(e);
    return true;
  }

  public void add(int index, Signature e) {
    modCount++;
    doAdd(index, e);
  }

  public Signature remove(int index) {
    modCount++;
    return doRemove(index);
  }

  protected void removeRange(int fromIndex, int toIndex) {
    modCount++;
    doRemoveRange(fromIndex, toIndex);
  }

  public int size() {
    return doSize();
  }

  public SignatureVec() {
    this(BlsJNI.new_SignatureVec__SWIG_0(), true);
  }

  public SignatureVec(SignatureVec other) {
    this(BlsJNI.new_SignatureVec__SWIG_1(SignatureVec.getCPtr(other), other), true);
  }

  public long capacity() {
    return BlsJNI.SignatureVec_capacity(swigCPtr, this);
  }

  public void reserve(long n) {
    BlsJNI.SignatureVec_reserve(swigCPtr, this, n);
  }

  public boolean isEmpty() {
    return BlsJNI.SignatureVec_isEmpty(swigCPtr, this);
  }

  public void clear() {
    BlsJNI.SignatureVec_clear(swigCPtr, this);
  }

  public SignatureVec(int count, Signature value) {
    this(BlsJNI.new_SignatureVec__SWIG_2(count, Signature.getCPtr(value), value), true);
  }

  private int doSize() {
    return BlsJNI.SignatureVec_doSize(swigCPtr, this);
  }

  private void doAdd(Signature x) {
    BlsJNI.SignatureVec_doAdd__SWIG_0(swigCPtr, this, Signature.getCPtr(x), x);
  }

  private void doAdd(int index, Signature x) {
    BlsJNI.SignatureVec_doAdd__SWIG_1(swigCPtr, this, index, Signature.getCPtr(x), x);
  }

  private Signature doRemove(int index) {
    return new Signature(BlsJNI.SignatureVec_doRemove(swigCPtr, this, index), true);
  }

  private Signature doGet(int index) {
    return new Signature(BlsJNI.SignatureVec_doGet(swigCPtr, this, index), false);
  }

  private Signature doSet(int index, Signature val) {
    return new Signature(BlsJNI.SignatureVec_doSet(swigCPtr, this, index, Signature.getCPtr(val), val), true);
  }

  private void doRemoveRange(int fromIndex, int toIndex) {
    BlsJNI.SignatureVec_doRemoveRange(swigCPtr, this, fromIndex, toIndex);
  }

}
