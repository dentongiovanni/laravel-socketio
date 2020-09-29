@extends('layouts.app')

@section('content')
    <example-component v-bind:user="{{ Auth::user() }}"></example-component>
@endsection
