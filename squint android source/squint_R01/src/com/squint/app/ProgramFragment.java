package com.squint.app;

import java.util.ArrayList;
import java.util.List;

import com.parse.ParseObject;
import com.squint.app.adapter.AbstractAdapter;
import com.squint.app.adapter.PosterAdapter;
import com.squint.app.adapter.TalkAdapter;
import com.squint.app.data.AbstractDAO;
import com.squint.app.data.PosterDAO;
import com.squint.app.data.TalkDAO;

import android.app.Fragment;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

public class ProgramFragment extends Fragment implements OnClickListener {
	
	public static final String		TAG = ProgramFragment.class.getSimpleName();
	public static Context			mContext;
	private IntentFilter			filter	 = null;  
    private BroadcastReceiver 		receiver = null;
	
	private TalkDAO 				mTalkDAO;
	private PosterDAO 				mPosterDAO;
	private AbstractDAO 			mAbstractDAO;
	public static List<ParseObject> mTalkData;
	public static List<ParseObject> mPosterData;
	public static List<ParseObject> mAbstractData;
	
	public static TalkAdapter		mTalkAdapter;
	public static PosterAdapter		mPosterAdapter;
	public static AbstractAdapter	mAbstractAdapter;

	public ListView 				mList;
	private Button mTalk;
	private Button mPoster;
	private Button mAbstract;
    
    
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mTalkDAO = new TalkDAO(mContext);
		mPosterDAO = new PosterDAO(mContext);
		mAbstractDAO = new AbstractDAO(mContext);
		mTalkData	= new ArrayList<ParseObject>();
		mPosterData	= new ArrayList<ParseObject>();	
		mAbstractData = new ArrayList<ParseObject>();
		View v = inflater.inflate(R.layout.fragment_program, container, false);
		mTalk = (Button)v.findViewById(R.id.switch_talk);
		mPoster = (Button)v.findViewById(R.id.switch_poster);
		mAbstract = (Button)v.findViewById(R.id.switch_abstract);
		mTalk.setOnClickListener(this);
		mPoster.setOnClickListener(this);
		mAbstract.setOnClickListener(this);
		
		mList = (ListView) v.findViewById(android.R.id.list);
		mList.setEmptyView(v.findViewById(android.R.id.empty));
		mTalkAdapter = new TalkAdapter(mContext, mTalkData);
		mPosterAdapter = new PosterAdapter(mContext, mPosterData);
		mAbstractAdapter = new AbstractAdapter(mContext, mAbstractData);
		onClick(mTalk);
		
        return v;	
        
	}
	
	public static ProgramFragment newInstance(Context context) {
		mContext = context;
        return new ProgramFragment();
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
        	filter.addAction(TalkDetailsActivity.ACTION_SELECT);
        	filter.addAction(PosterDetailsActivity.ACTION_SELECT);
        	filter.addAction(AbstractDetailsActivity.ACTION_SELECT);
        	filter.addAction(TalkDAO.ACTION_LOAD_DATA);
        	filter.addAction(PosterDAO.ACTION_LOAD_DATA);
        	filter.addAction(AbstractDAO.ACTION_LOAD_DATA);
        }  
        return filter;
    }
	
	class IntentReceiver extends BroadcastReceiver {  
		  
        @Override  
        public void onReceive(Context context, Intent intent) {
        	Log.d(TAG, "onReceive");
        	String action = intent.getAction();
        	
            if (action.equals(TalkDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, TalkDetailsActivity.class);
            	
            } else if (action.equals(PosterDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, PosterDetailsActivity.class);
            	
            } else if (action.equals(AbstractDetailsActivity.ACTION_SELECT)) {
            	toPage(intent, AbstractDetailsActivity.class);
            	//toast(intent.getStringExtra(AbstractAdapter.EXTRA_ABSTRACT_ID));
            	
            } else if (action.equals(TalkDAO.ACTION_LOAD_DATA)) {
            	try {
            		mTalkData = mTalkDAO.getData();
            		mTalkAdapter.update(mTalkData);
            	} catch (Exception e) { Log.d(TAG, "Talk data is null!"); }
            } else if (action.equals(PosterDAO.ACTION_LOAD_DATA)) {
            	try {
            	mPosterData = mPosterDAO.getData();
            	mPosterAdapter.update(mPosterData);
            	} catch (Exception e) { Log.d(TAG, "Poster data is null!"); }
            } else if (action.equals(AbstractDAO.ACTION_LOAD_DATA)) {
            	try {
            		mAbstractData = mAbstractDAO.getData();
            		mAbstractAdapter.update(mAbstractData);
            	} catch (Exception e) { Log.d(TAG, "Abstract data is null!"); }
            	
            }         
        }  
    }
	
	private <T> void toPage(Intent intent, Class<T> cls) {
		intent.setClass(mContext, cls);
		startActivity(intent);
	    getActivity().overridePendingTransition (R.anim.page_left_slide_in, R.anim.page_left_slide_out);
	}

	public void toast(String message) {
    	Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show();
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.switch_talk:
			mList.setAdapter(mTalkAdapter);
			mTalk.setSelected(true);
			mPoster.setSelected(false);
			mAbstract.setSelected(false);
			mTalk.setEnabled(false);
			mPoster.setEnabled(true);
			mAbstract.setEnabled(true);
			//toast("Talk");
			break;
		case R.id.switch_poster:
			mList.setAdapter(mPosterAdapter);
			mTalk.setSelected(false);
			mPoster.setSelected(true);
			mAbstract.setSelected(false);
			mTalk.setEnabled(true);
			mPoster.setEnabled(false);
			mAbstract.setEnabled(true);			
			//toast("Poster");
			break;
		case R.id.switch_abstract:
			mList.setAdapter(mAbstractAdapter);
			mTalk.setSelected(false);
			mPoster.setSelected(false);
			mAbstract.setSelected(true);
			mTalk.setEnabled(true);
			mPoster.setEnabled(true);
			mAbstract.setEnabled(false);			
			//toast("Abstract");
			break;
		}
		
	}	

}
