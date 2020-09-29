<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');


Route::post('/send-notification', function (Request $request) {
   event(new \App\Events\NotificationEvent());
 });


Route::post('/send-private-message', function (Request $request) {
    $user = \App\Models\User::where('email',$request->email)->first();
    $message = $request->message;
    event(new \App\Events\UserEvent($user, $message,$request->sender));
 });


 Route::post('/send-public-message', function (Request $request) {
    event(new \App\Events\ChatEvent($request->message,$request->sender));
 });
 
 


