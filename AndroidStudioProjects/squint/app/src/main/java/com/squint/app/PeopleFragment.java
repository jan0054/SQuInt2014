package com.squint.app;

import java.util.ArrayList;
import java.util.List;

import com.parse.ParseObject;
import com.squint.app.adapter.PeopleAdapter;
import com.squint.app.data.PeopleDAO;

import android.app.Fragment;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.Toast;

public class PeopleFragment extends Fragment {
	
	public static final String		TAG = PeopleFragment.class.getSimpleName();
	public static Context			mContext;
	private IntentFilter			filter	 = null;  
    private BroadcastReceiver 		receiver = null;
    
	private PeopleDAO 				mPeople;
	public List<ParseObject> 		mData;
	public ListView 				mList;
	public static PeopleAdapter		mAdapter;
    
    
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mPeople = new PeopleDAO(mContext);
		mData	= new ArrayList<ParseObject>();
		
		View v = inflater.inflate(R.layout.fragment_general, container, false);
		mList = (ListView) v.findViewById(android.R.id.list);
		mList.setEmptyView(v.findViewById(android.R.id.empty));
		mAdapter = new PeopleAdapter(mContext, mData);
		mList.setAdapter(mAdapter);	
        return v;	
        
	}
	
	public static PeopleFragment newInstance(Context context) {
		mContext = context;
        return new PeopleFragment();
    }
	
	
	@Override  
    public void onResume() {
        super.onResume();
        if (receiver == null) receiver = new IntentReceiver();  
        mContext.registerReceiver(receiver, getIntentFilter());
    }
	
	@Override  
    public void onPause() {  
        super.onPause();  
        mContext.unregisterReceiver(receiver);
    }
	
	private IntentFilter getIntentFilter() {  
        if (filter == null) {  
        	filter = new IntentFilter();  
        	filter.addAction(PeopleAdapter.ACTION_PERSON_SELECT);
        	filter.addAction(PeopleDAO.ACTION_LOAD_DATA);
        }  
        return filter;
    }
	
	class IntentReceiver extends BroadcastReceiver {  
		  
        @Override  
        public void onReceive(Context context, Intent intent) {
        	Log.d(TAG, "onReceive");
        	String action = intent.getAction(); 	
            if (action.equals(PeopleAdapter.ACTION_PERSON_SELECT)) {
            	//toast(intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_ID));
            	toPage(intent, PeopleDetailsActivity.class);
            } else if (action.equals(PeopleDAO.ACTION_LOAD_DATA)) {
            	mData = mPeople.getData();
            	mAdapter.update(mData);
            	//toast(intent.getStringExtra(PeopleAdapter.EXTRA_PERSON_ID));
            }
        }  
    }
	
	private <T> void toPage(Intent intent, Class<T> cls) {
		intent.setClass(mContext, cls); //PeopleDetailsActivity.class);
		startActivity(intent);
	    getActivity().overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);
	}

	public void toast(String message) {
    	Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show();
	}	
	
}
