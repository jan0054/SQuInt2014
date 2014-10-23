package com.squint.app;

import com.parse.LogInCallback;
import com.parse.ParseException;
import com.parse.ParseUser;
import com.squint.app.widget.BaseActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

public class LoginActivity extends BaseActivity {
	
	public static final String TAG = LoginActivity.class.getSimpleName();
	private EditText mUsername;
	private EditText mPassword;
	private boolean isFromSettings;

	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_login);
		
		mTitle.setText(getString(R.string.title_login));
		mUsername = (EditText) findViewById(R.id.username);
		mPassword = (EditText) findViewById(R.id.password);
		if (isLogin()) skip(null);
	}
	
	@Override
	public void onResume() {		
		super.onResume();
		isFromSettings = getIntent().getBooleanExtra(FROM, false);
		Log.d(TAG, "From Settings? " + isFromSettings);
	}
	
	public void skip(View view) {
		if (view == null) isFromSettings = false;
		if (isFromSettings) {
			onBackPressed();
		} else {
			Intent intent = new Intent(this, MainActivity.class);	
			intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP|Intent.FLAG_ACTIVITY_CLEAR_TASK|Intent.FLAG_ACTIVITY_NEW_TASK);
		    startActivity(intent);
		    overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);
		}
	}
	
	@Override
	public void onBackPressed() {
		super.onBackPressed();
	    overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);
	}
	
	
	public void login(View view) {
		String username = mUsername.getText().toString();
		String password = mPassword.getText().toString();
		
		// TODO: Add more check-out for username and password!
		if (username.length() == 0 || password.length() == 0) {
			toast("Wrong username and/or password!");
			return;
		}
		
		ParseUser.logInInBackground(username, password,
									new LogInCallback() {
										@Override
										public void done(ParseUser user, ParseException e) {
											if (user != null) {
											      Log.d(TAG, "Login: " + "passed");
											      new Handler().postDelayed(new Runnable() {
											            public void run() {
														      skip(null);
											            }
											        }, 100);
											    } else {
												  Log.d(TAG, "Login: " + "failed");
												  final int code = e.getCode();
												  final String msg = e.getMessage();
											      new Handler().postDelayed(new Runnable() {
											            public void run() {
														      onLoginFailed(code, msg);
											            }
											        }, 100);
											    }										
										}					
		});
		
		Log.d(TAG, "U/P: " + mUsername.getText().toString() + ", " + mPassword.getText().toString());
	}
	
	public void toSignupPage(View view) {
		Intent intent = new Intent(this, SignupActivity.class);
	    startActivity(intent);
	    overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);		
	}
	
	private void onLoginFailed(int code, String msg) {
		toast("Error (" + code + "): " + msg + "!");
	}
	
	
}
